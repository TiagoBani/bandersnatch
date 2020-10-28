const MANIFEST_URL = 'manifest.json'
const localHost = ['localhost', '127.0.0.1']

async function main () {
  const isLocal = !!~localHost.indexOf(window.location.hostname)
  console.log({ isLocal })
  const manifestJSON = await (await fetch(MANIFEST_URL)).json()

  const host = isLocal ? manifestJSON.localHost : manifestJSON.productionHost
  const videoComponent = new VideoComponent()

  const network = new Network({ host })
  const videoPlayer = new VideoPlayer({
    manifestJSON, network
  })

  videoPlayer.inicializeCodec()
  videoComponent.inicializePlayer()
}

window.onload = main
