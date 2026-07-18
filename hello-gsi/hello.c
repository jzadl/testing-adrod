#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include <sys/mman.h>
#include <linux/fb.h>
#include <linux/input.h>

#define FONT_W 8
#define FONT_H 16
#define SCALE 4

static const unsigned char font_data[128][16] = {
    ['H'] = {0x00,0x00,0x66,0x66,0x66,0x7E,0x7E,0x66,0x66,0x66,0x66,0x66,0x00,0x00,0x00,0x00},
    ['e'] = {0x00,0x00,0x00,0x00,0x38,0x6C,0x6C,0x7E,0x6C,0x6C,0x6C,0x38,0x00,0x00,0x00,0x00},
    ['l'] = {0x00,0x00,0x18,0x18,0x38,0x18,0x18,0x18,0x18,0x18,0x18,0x3C,0x00,0x00,0x00,0x00},
    ['o'] = {0x00,0x00,0x00,0x00,0x3C,0x66,0x66,0x66,0x66,0x66,0x66,0x3C,0x00,0x00,0x00,0x00},
    ['w'] = {0x00,0x00,0x00,0x00,0x00,0x63,0x63,0x6B,0x7F,0x36,0x36,0x36,0x00,0x00,0x00,0x00},
    ['r'] = {0x00,0x00,0x00,0x00,0x3C,0x6E,0x6E,0x6C,0x6C,0x60,0x60,0x60,0x00,0x00,0x00,0x00},
    ['d'] = {0x00,0x00,0x00,0x00,0x1C,0x36,0x36,0x30,0x30,0x36,0x36,0x1C,0x00,0x00,0x00,0x00},
    ['W'] = {0x00,0x00,0x00,0x63,0x63,0x63,0x7F,0x36,0x36,0x36,0x36,0x36,0x00,0x00,0x00,0x00},
    [':'] = {0x00,0x00,0x00,0x00,0x00,0x18,0x18,0x00,0x00,0x18,0x18,0x00,0x00,0x00,0x00,0x00},
    [')'] = {0x00,0x00,0x00,0x00,0x30,0x18,0x0C,0x0C,0x0C,0x0C,0x18,0x30,0x00,0x00,0x00,0x00},
};

static int fb_fd;
static unsigned char *fb_mem;
static struct fb_var_screeninfo vinfo;
static int fb_size;

static inline unsigned int make_color(unsigned char r, unsigned char g, unsigned char b) {
    unsigned int c = 0;
    c |= ((unsigned int)r >> (8 - vinfo.red.length)) << vinfo.red.offset;
    c |= ((unsigned int)g >> (8 - vinfo.green.length)) << vinfo.green.offset;
    c |= ((unsigned int)b >> (8 - vinfo.blue.length)) << vinfo.blue.offset;
    return c;
}

static void put_pixel(int x, int y, unsigned int color) {
    if (x < 0 || x >= (int)vinfo.xres || y < 0 || y >= (int)vinfo.yres) return;
    int offset = (y * vinfo.xres + x) * (vinfo.bits_per_pixel / 8);
    if (offset + 4 > fb_size) return;
    if (vinfo.bits_per_pixel == 32)
        *(unsigned int *)(fb_mem + offset) = color;
    else if (vinfo.bits_per_pixel == 16)
        *(unsigned short *)(fb_mem + offset) = (unsigned short)color;
}

static void draw_char(int x, int y, char ch, unsigned int color) {
    int idx = (unsigned char)ch;
    if (idx >= 128) return;
    const unsigned char *glyph = font_data[idx];
    for (int row = 0; row < FONT_H; row++) {
        unsigned char bits = glyph[row];
        for (int col = 0; col < FONT_W; col++) {
            if (bits & (0x80 >> col)) {
                for (int sy = 0; sy < SCALE; sy++)
                    for (int sx = 0; sx < SCALE; sx++)
                        put_pixel(x + col * SCALE + sx, y + row * SCALE + sy, color);
            }
        }
    }
}

static void draw_string(int x, int y, const char *str, unsigned int color) {
    while (*str) {
        draw_char(x, y, *str, color);
        x += FONT_W * SCALE;
        str++;
    }
}

static void clear_screen(unsigned int color) {
    unsigned int *p = (unsigned int *)fb_mem;
    int pixels = vinfo.xres * vinfo.yres;
    for (int i = 0; i < pixels; i++)
        p[i] = color;
}

static int find_touch_device(void) {
    char path[64];
    for (int i = 0; i < 16; i++) {
        snprintf(path, sizeof(path), "/dev/input/event%d", i);
        int fd = open(path, O_RDONLY | O_NONBLOCK);
        if (fd < 0) continue;
        unsigned long bits[1 + ABS_CNT / (sizeof(unsigned long) * 8)];
        memset(bits, 0, sizeof(bits));
        if (ioctl(fd, EVIOCGBIT(EV_ABS, sizeof(bits)), bits) >= 0) {
            if (bits[ABS_MT_POSITION_X / (sizeof(unsigned long) * 8)] &
                (1UL << (ABS_MT_POSITION_X % (sizeof(unsigned long) * 8)))) {
                fprintf(stderr, "Found touch at %s\n", path);
                return fd;
            }
        }
        close(fd);
    }
    fprintf(stderr, "No touch, using event0\n");
    return open("/dev/input/event0", O_RDONLY);
}

int main(void) {
    mount("proc", "/proc", "proc", 0, NULL);
    mount("sysfs", "/sys", "sysfs", 0, NULL);
    mount("devtmpfs", "/dev", "devtmpfs", 0, NULL);

    fprintf(stderr, "Hello World GSI booting...\n");

    const char *fb_paths[] = {"/dev/graphics/fb0", "/dev/fb0", NULL};
    fb_fd = -1;
    for (int i = 0; fb_paths[i]; i++) {
        fb_fd = open(fb_paths[i], O_RDWR);
        if (fb_fd >= 0) break;
    }
    if (fb_fd < 0) {
        perror("open fb");
        return 1;
    }
    if (ioctl(fb_fd, FBIOGET_VSCREENINFO, &vinfo) < 0) {
        perror("ioctl");
        return 1;
    }
    fprintf(stderr, "FB: %dx%d %dbpp\n", vinfo.xres, vinfo.yres, vinfo.bits_per_pixel);

    fb_size = vinfo.xres * vinfo.yres * (vinfo.bits_per_pixel / 8);
    fb_mem = mmap(NULL, fb_size, PROT_READ | PROT_WRITE, MAP_SHARED, fb_fd, 0);
    if (fb_mem == MAP_FAILED) {
        perror("mmap");
        return 1;
    }

    unsigned int bg = make_color(0, 0, 0);
    unsigned int fg = make_color(255, 255, 255);
    clear_screen(bg);

    const char *msg = "Hello world :)";
    int text_w = (int)strlen(msg) * FONT_W * SCALE;
    int text_h = FONT_H * SCALE;
    int x = ((int)vinfo.xres - text_w) / 2;
    int y = ((int)vinfo.yres - text_h) / 2;
    draw_string(x, y, msg, fg);

    fprintf(stderr, "Touch to blank screen\n");

    int ts_fd = find_touch_device();
    if (ts_fd < 0) {
        perror("open touch");
        return 1;
    }

    struct input_event ev;
    while (1) {
        ssize_t n = read(ts_fd, &ev, sizeof(ev));
        if (n == (ssize_t)sizeof(ev) && ev.type == EV_ABS) {
            fprintf(stderr, "Touch! Blanking...\n");
            ioctl(fb_fd, FB_BLANK_NORMAL, 0);
            break;
        }
        usleep(10000);
    }

    close(ts_fd);
    close(fb_fd);
    return 0;
}
