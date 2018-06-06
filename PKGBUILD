# Maintainer: Edmunt Pienkowsky <roed@onet.eu>

pkgname='icecast-rec'
pkgdesc='icecast - broadcasting audio directly from sound card'
pkgver='1'
pkgrel='1'
arch=('any')
license=('BSD')
depends=('icecast' 'libxslt' 'ffmpeg' 'alsa-utils')
optdepends=('mailcap: for mime.types file')

source=( 
    'icecast-rec.service'
    'icecast-rec-source.service'
    'icecast-source.sh'
    'icecast-notify.sh'
    'icecast.xml'
    'icecast.xsl'
    'env'
)

backup=(
    'etc/conf.d/icecast-rec'
    'etc/icecast-rec.xml'
)

sha256sums=('d10abc2e01e0fe0148ed9b93070d73dcd1236124b5ce985dd61dd0af4d09f00e'
            '7d9af4b58b6e43d3d47c2340d653880cd2c2c42e7dd219f3675c04b0340a9b07'
            'd6d53cf06889ce31824fca463300ec117d1a2c7e4cbbe3dd012fba15431bffb8'
            '6518412a66065b3fc38890f99d8060b83a6327185470d045eaf45ad2e2b314d9'
            'f6380bc248d93eb9d38ad7385c9b8e909115a5260e39487570e8a8aa5f47204c'
            '2aa5711ae409e6a692541e936e3fa0d3f954117b9d1723ba605074e5a4483d09'
            '5b5240e468d8134d1366d4bc77c2ea42b12ca262c72af218420be156555ca6cb')

package(){
	install -d -m 0755 ${pkgdir}/usr/lib/systemd/system
	install -p -m 0644 ${srcdir}/icecast-rec.service ${pkgdir}/usr/lib/systemd/system
        install -p -m 0644 ${srcdir}/icecast-rec-source.service ${pkgdir}/usr/lib/systemd/system

        install -d -m 0755 ${pkgdir}/etc/conf.d
        install -p -m 0644 ${srcdir}/icecast.xml ${pkgdir}/etc/icecast-rec.xml
        install -p -m 0644 ${srcdir}/env ${pkgdir}/etc/conf.d/icecast-rec

	install -d -m 0755 ${pkgdir}/usr/lib/icecast-rec
	install -p -m 0644 ${srcdir}/icecast.xsl ${pkgdir}/usr/lib/icecast-rec
        install -p -m 0755 ${srcdir}/icecast-source.sh ${pkgdir}/usr/lib/icecast-rec/icecast-source
        install -p -m 0755 ${srcdir}/icecast-notify.sh ${pkgdir}/usr/lib/icecast-rec/icecast-notify
        ln -s 'icecast-notify' "${pkgdir}/usr/lib/icecast-rec/icecast-on-connect"
        ln -s 'icecast-notify' "${pkgdir}/usr/lib/icecast-rec/icecast-on-disconnect"
}
