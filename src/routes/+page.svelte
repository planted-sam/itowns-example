<script>
    import { onMount } from "svelte";
    let { data } = $props();
    const testTerrainUuid = "5efff2b1-2024-462a-9dc0-df9451febc7f";
    const testDEMUuid = "3e2c0346-35ef-483f-b6a0-86ab9555305c";

    $effect(() => {
        if (data.maptilerAPIKey !== undefined) {
            console.log(data.maptilerAPIKey);
        }
    });

    onMount(async () => {
        let itowns = await import("itowns");
        // define UTM 16N so we can provide the initial bounds (here 'Extent') for the map in UTM 16N
        itowns.CRS.defs(
            "EPSG:32616",
            "+proj=utm +zone=16 +datum=WGS84 +units=m +no_defs +type=crs",
        );
        let extent = new itowns.Extent(
            "EPSG:32616",
            694186.0191999999806285,
            693794.1574999999720603,
            4806866.0176999997347593,
            4807281.6841000001877546,
        );
        let view = new itowns.GlobeView(viewer, extent);
        // Add a satelite source
        let tmsSateliteSource = new itowns.TMSSource({
            name: "maptiler_staelite",
            // satelite tiles from maptiler
            url: `https://api.maptiler.com/tiles/satellite-v2/\${z}/\${x}/\${y}.jpg?key=${data.maptilerAPIKey}`,
            crs: "EPSG:3857", // web mercator
            format: "image/png",
        });
        tmsSateliteSource.zoom.max = 40;

        // Add satelite layer
        let tmsImageryLayer = new itowns.ColorLayer("satelite", {
            updateStrategy: {
                type: itowns.STRATEGY_DICHOTOMY,
                options: {},
            },
            source: tmsSateliteSource,
        });

        view.addLayer(tmsImageryLayer);

        // Add a hillshade source
        let demHillshadeSource = new itowns.TMSSource({
            name: "dem-hillshade",
            url: `http://localhost:3012/terrains/${testTerrainUuid}/dems/${testDEMUuid}/tiles/hillshade/\${z}/\${x}/\${y}`,
            crs: "EPSG:3857", // web mercator - future tileserver output could be in diff CRS
            format: "image/png",
        });
        demHillshadeSource.zoom.max = 40;
        demHillshadeSource.zoom.min = 15;

        // Add hillshade layer
        let demHillshadeLayer = new itowns.ColorLayer("hillshade", {
            updateStrategy: {
                type: itowns.STRATEGY_DICHOTOMY,
                options: {},
            },
            source: demHillshadeSource,
        });

        view.addLayer(demHillshadeLayer);

        // Add a WMS elevation source
        let elevationSource = new itowns.TMSSource({
            extent: extent,
            url: `http://localhost:3012/terrains/${testTerrainUuid}/dems/${testDEMUuid}/tiles/terrarium/\${z}/\${x}/\${y}`,
            name: "test_dem_elevation",
            crs: "EPSG:3857",
            format: "image/png",
        });

        // Add a elevation layer
        let elevationLayer = new itowns.ElevationLayer("wms_elevation", {
            source: elevationSource,
        });

        view.addLayer(elevationLayer);
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
