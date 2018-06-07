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

sha256sums=('d10abc2e01e0fe0148ed9b93070d73dcd1236124b5ce985dd61dd0af4d09f00e'
            '14a6373c3403e058fa1aa17fc7cbb5ea51946dc876746c54efc9e220c38f3818'
            '66473e6328da837f205f44bfdff3c9eeba0b7af893f59d453583423606ef1bad'
            '6518412a66065b3fc38890f99d8060b83a6327185470d045eaf45ad2e2b314d9'
            'f6380bc248d93eb9d38ad7385c9b8e909115a5260e39487570e8a8aa5f47204c'
            '2aa5711ae409e6a692541e936e3fa0d3f954117b9d1723ba605074e5a4483d09'
            '0314192a4d2fac2b46d5994b9627d3cea1258245fda6a6c509f2204a53e22caf'
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
