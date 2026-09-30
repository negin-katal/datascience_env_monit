# flux4student: FLUXNET Site Explorer

Interactive viewer for the global FLUXNET eddy-covariance dataset used in the flux4student
project: **https://negin-katal.github.io/datascience_env_monit/flux4student/**

- **Map:** every tower, coloured by vegetation type (IGBP class, grouped). Click a site to open its data.
- **Data availability:** one row per site and one column per year, shaded by the share of good-quality CO₂ flux data.
- **Time series:** weekly air and soil temperature, precipitation, VPD, radiation, soil water, GPP, ecosystem respiration, NEE, latent and sensible heat, and NEE data quality.

`sites.json` holds the site metadata and citations. `data/<SITE>.json` holds weekly values
aggregated from the FLUXNET daily files (means; precipitation as weekly totals; weeks with fewer
than 4 days of data are left empty). The full half-hourly data are not in this repository.

## Data and citation

FLUXNET data products (ONEFlux v1.3, 2026 release), downloaded with the FLUXNET Shuttle from AmeriFlux,
the ICOS Carbon Portal and TERN. Licence: CC-BY-4.0. When using the data, cite each site's data product
(the `cite` field in `sites.json`), cite Pastorello et al. (2020), *Scientific Data* 7, 225,
https://doi.org/10.1038/s41597-020-0534-3, and include the FLUXNET acknowledgement:

> FLUXNET data products were produced and harmonized by eddy covariance regional networks and data
> processing centers, including AmeriFlux, ChinaFlux, European Fluxes Database, ICOS, JapanFlux, KoFlux,
> OzFlux, SAEON, and TERN. These products also include a modified version of ERA5 hourly data provided by
> the Copernicus Climate Change Service.

To run the viewer locally, serve this folder (for example `python3 -m http.server`) and open `index.html`.
Opening the file directly from disk will not load the data.
