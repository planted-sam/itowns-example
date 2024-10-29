<script>
    import { onMount } from "svelte";
    onMount(async () => {
        let itowns = await import("itowns");

        // Following guide at http://www.itowns-project.org/itowns/docs/#tutorials/3DTiles-mesh-b3dm
        // With some updates to account for updates to itowns
        itowns.CRS.defs(
            "EPSG:3946",
            "+proj=lcc +lat_1=45.25 +lat_2=46.75 +lat_0=46 +lon_0=3 +x_0=1700000 +y_0=5200000 +ellps=GRS80" +
                "+towgs84=0,0,0,0,0,0,0 +units=m +no_defs",
        );
        let extent = new itowns.Extent("EPSG:3946", 1837816.94334, 1847692.32501,
            5170036.4587, 5178412.82698);
        let cameraCoord = new itowns.Coordinates('EPSG:3946', 1841980,
            5175682, 3000)
        let view = new itowns.PlanarView(viewer, extent, {
          placement: {
              coord: cameraCoord, heading: 30, range: 4000, tilt: 30 }
        });
        
        // Add a WMS imagery source
        let wmsImagerySource = new itowns.WMSSource({
            extent: extent,
            name: 'ortho_latest',
            url: 'https://imagerie.data.grandlyon.com/wms/grandlyon',
            version: '1.3.0',
            crs: 'EPSG:3946',
            format: 'image/jpeg',
        });
        
        // Add a WMS imagery layer
        let wmsImageryLayer = new itowns.ColorLayer('wms_imagery', {
            updateStrategy: {
                type: itowns.STRATEGY_DICHOTOMY,
                options: {},
            },
            source: wmsImagerySource,
        });
        
        view.addLayer(wmsImageryLayer);
        
        // Add a WMS elevation source
        let wmsElevationSource = new itowns.WMSSource({
            extent: extent,
            url: 'https://download.data.grandlyon.com/wms/grandlyon',
            name: 'MNT2012_Altitude_10m_CC46',
            crs: 'EPSG:3946',
            width: 256,
            format: 'image/jpeg',
        });
        
        // Add a WMS elevation layer
        let wmsElevationLayer = new itowns.ElevationLayer('wms_elevation', {
            useColorTextureElevation: true,
            colorTextureElevationMinZ: 144,
            colorTextureElevationMaxZ: 622,
            source: wmsElevationSource,
        });
        
        view.addLayer(wmsElevationLayer);

    });
    let viewer;
</script>

<div id="viewer" bind:this={viewer}></div>

<style>
    #viewer {
        margin: auto;
        height: 98vh;
        width: 98vw;
        padding: 0;
    }
</style>
