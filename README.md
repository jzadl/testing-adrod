# CyanogenMod 14.1 Build for Samsung J7 Neo (SM-J701F)

## Dispositivo

- **Nombre**: Samsung Galaxy J7 Neo / J7 Nxt / J7 Core
- **Modelo**: SM-J701F / SM-J701M
- **Codename**: `j7velte`
- **SoC**: Samsung Exynos 7870 (Octa-core 1.6 GHz Cortex-A53)
- **GPU**: Mali-T830 MP1
- **RAM**: 2GB / 3GB
- **Almacenamiento**: 16GB / 32GB
- **Android stock**: 7.0 Nougat (actualizable a 9.0 Pie)

## Estructura del Repositorio

```
testing-adrod/
├── .github/
│   └── workflows/
│       └── build.yml          # Workflow de GitHub Actions
├── README.md
└── manifest.xml               # Manifest local (opcional)
```

## Uso

### Opción 1: GitHub Actions (Recomendado)

1. Crea un repositorio en GitHub llamado `testing-adrod`
2. Sube estos archivos
3. Ve a la pestaña **Actions**
4. Selecciona **Build CyanogenMod 14.1 for Samsung J7 Neo**
5. Haz clic en **Run workflow**
6. Selecciona la versión de Android (13.0 o 14.1)

### Opción 2: Build Local

```bash
# Instalar dependencias (Ubuntu 16.04/18.04)
sudo apt update && sudo apt install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32readline-dev lib32z1-dev libelf-dev liblz4-tool libncurses5 libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev openjdk-8-jdk python3

# Configurar ccache
mkdir -p ~/.ccache
echo "max_size = 10G" > ~/.ccache/ccache.conf

# Instalar repo
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

# Inicializar manifest de CyanogenMod
mkdir android/cm && cd android/cm
repo init -u https://github.com/CyanogenMod/android.git -b cm-14.1 --depth=1

# Agregar manifests locales del dispositivo
mkdir -p .repo/local_manifests
cat > .repo/local_manifests/j7velte.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="samsungexynos7870/android_kernel_samsung_exynos7870"
           path="kernel/samsung/exynos7870"
           remote="github"
           revision="master" />
  <project name="samsungexynos7870/android_device_samsung_j7velte"
           path="device/samsung/j7velte"
           remote="github"
           revision="aex" />
  <project name="samsungexynos7870/android_device_samsung_exynos7870-common"
           path="device/samsung/exynos7870-common"
           remote="github"
           revision="aex" />
  <project name="samsungexynos7870/proprietary_vendor_samsung"
           path="vendor/samsung"
           remote="github"
           revision="aex" />
</manifest>
EOF

# Sincronizar
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

# Compilar
source build/envsetup.sh
lunch cm_j7velte-userdebug
mka bacon -j$(nproc --all)
```

## Archivos de Salida

Después del build, encontrarás:
```
out/target/product/j7velte/
├── cm-14.1-YYYYMMDD-UNOFFICIAL-j7velte.zip  # ZIP para instalar
└── recovery.img                              # Recovery image
```

## Requisitos Adicionales

### Vendor Blobs (Archivos propietarios)

El device tree requiere los archivos propietarios de Samsung. Estos se encuentran en:
- `samsungexynos7870/proprietary_vendor_samsung` (branch `aex`)

Si no están disponibles, necesitarás extraerlos de una ROM stock:
1. Descarga la ROM stock para SM-J701F
2. Extrae los archivos usando `extract-files.sh` del device tree
3. Colócalos en `vendor/samsung/j7velte/`

### Kernel

El kernel fuente está en:
- `samsungexynos7870/android_kernel_samsung_exynos7870` (rama `master`)
- Versión: Linux 3.x (compatible con CyanogenMod 14.1)

## Solución de Problemas

### Error: "No space left on device"
- GitHub Actions tiene ~14GB de espacio libre
- Los builds de CyanogenMod pueden ocupar 15-25GB
- Considera usar un self-hosted runner

### Error: "Vendor blobs missing"
- Verifica que el repositorio `proprietary_vendor_samsung` esté sincronizado
- Si no existe, extrae de una ROM stock

### Error: "Build failed"
- Revisa el build log en los artifacts del workflow
- Verifica que las branches de los repos sean correctas
- Asegúrate de usar Ubuntu 16.04/18.04 (no 22.04+)

## Notas Importantes

1. **CyanogenMod 14.1** está basado en **Android 7.1.x Nougat**
2. El kernel es **Linux 3.x** (muy antiguo, pero compatible)
3. Los chipsets Exynos son notoriamente difíciles para custom ROMs
4. El primer build puede tardar 2-4 horas
5. Los builds subsiguientes serán más rápidos debido a ccache

## Enlaces Útiles

- [CyanogenMod GitHub](https://github.com/CyanogenMod)
- [Device Tree j7velte](https://github.com/samsungexynos7870/android_device_samsung_j7velte)
- [Kernel Exynos7870](https://github.com/samsungexynos7870/android_kernel_samsung_exynos7870)
- [XDA Forums - J7 Neo](https://forum.xda-developers.com/c/samsung-galaxy-j7.5263/)
