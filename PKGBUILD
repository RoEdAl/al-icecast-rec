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
    'env-source'
)

backup=(
    'etc/conf.d/icecast-rec'
    'etc/conf.d/icecast-rec-source'
    'etc/icecast-rec.xml'
)

sha256sums=('2808fc3011a080dfa6ac926301e79a62121fa169ea78af8222c1d9d5b1d82cbd'
            '438c5d091c7a18128ed21c294c17414ff2fe1e2e14bed87cb8286e068bf6ade0'
            '5aa0188854038e20044a9388c813a1b3ee080404d4ad6f707765503aa12d1ea7'
            '6518412a66065b3fc38890f99d8060b83a6327185470d045eaf45ad2e2b314d9'
            'e96b061e77901e16dbe59c876b85d70ebb4cbee3218ceaca618dba7abc699e40'
            '1d13e88013dcd90b41e15d4b3426f1d7c30a5885385b7445d47daed4feb2bfd7'
            '7ae24befe514f922e5b2c9df87d23e50510811aded3a094f758e362c8db5e855'
            'e09df9ec79aeab83df434a15c2a4d52aac5de5b8bdb5e2fdd355938c0a04ae0f')

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
