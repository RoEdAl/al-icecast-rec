# Maintainer: Edmunt Pienkowsky <roed@onet.eu>

pkgname='icecast-rec'
pkgdesc='icecast - broadcasting audio directly from sound card'
pkgver='2'
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
    'env-source'
)

backup=(
    'etc/conf.d/icecast-rec'
    'etc/conf.d/icecast-rec-source'
    'etc/icecast-rec.xml'
)

sha256sums=('e9d5279a2f69a8425c4c05114b80ed215c63b534f9ca3dce8b5709f9ec194772'
            'f5b45588463813c8c48990ab410bb22e969f990d4b096c0c96331bcf9fc10242'
            'b2dceec0443c9ba2a92d93cf5b95e26b034f63e700af96972c5fdc1a40dabd45'
            '6518412a66065b3fc38890f99d8060b83a6327185470d045eaf45ad2e2b314d9'
            '4d00c33e05fccd895b5b1bfc5924e610bf2d0268e46b8f0c5b616d8b5401a450'
            '1d13e88013dcd90b41e15d4b3426f1d7c30a5885385b7445d47daed4feb2bfd7'
            '7ae24befe514f922e5b2c9df87d23e50510811aded3a094f758e362c8db5e855'
            '3ae818a88c5c3f765e0a75902485853c8c4a7eb9da49a5d0e867e07ac98dfc61')

package(){
	install -d -m 0755 ${pkgdir}/usr/lib/systemd/system
	install -p -m 0644 ${srcdir}/icecast-rec.service ${pkgdir}/usr/lib/systemd/system
        install -p -m 0644 ${srcdir}/icecast-rec-source.service ${pkgdir}/usr/lib/systemd/system

        install -d -m 0755 ${pkgdir}/etc/conf.d
        install -p -m 0644 ${srcdir}/icecast.xml ${pkgdir}/etc/icecast-rec.xml
        install -p -m 0644 ${srcdir}/env ${pkgdir}/etc/conf.d/icecast-rec
        install -p -m 0644 ${srcdir}/env-source ${pkgdir}/etc/conf.d/icecast-rec-source

	install -d -m 0755 ${pkgdir}/usr/lib/icecast-rec
	install -p -m 0644 ${srcdir}/icecast.xsl ${pkgdir}/usr/lib/icecast-rec
        install -p -m 0755 ${srcdir}/icecast-source.sh ${pkgdir}/usr/lib/icecast-rec/icecast-source
        install -p -m 0755 ${srcdir}/icecast-notify.sh ${pkgdir}/usr/lib/icecast-rec/icecast-notify
        ln -s 'icecast-notify' "${pkgdir}/usr/lib/icecast-rec/icecast-on-connect"
        ln -s 'icecast-notify' "${pkgdir}/usr/lib/icecast-rec/icecast-on-disconnect"
}
