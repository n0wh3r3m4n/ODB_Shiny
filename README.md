# Barómetro de Datos Abiertos

El [barómetro de datos abiertos](https://opendatabarometer.org) mide la publicación y uso de datos en tres dimensiones: preparación, implementación e impacto. La metodología fue creada por la [World Wide Web Foundation](https://webfoundation.org) y su primera versión fue publicada en 2013. La última medición global del barómetro se realizó en 2017.

En 2020, con el apoyo de varias multilaterales y donantes, la [Iniciativa Latinoamericana de Datos Abiertos](https://idatosabiertos.org) (ILDA) realizó una edición que incluye 24 países de América Latina y el Caribe, disponible en: [https://barometrolac.org/](https://barometrolac.org/).

Si bien la página de ILDA incluye una herramienta de comparación de países, me interesaba poder ver las tres dimensiones en una sóla visualización, así como la comparación entre países y la posibilidad de analizar la evolución de cada país por dimensión. La aplicación resultante en shiny se puede consultar [aquí](https://n0wh3r3m4n.shinyapps.io/shiny_odb/).

Este repositorio incluye el script en R para generar las tablas del barómetro por año (se alimenta de la información de ILDA), las tablas que se han generado (una general y una por cada dimensión) y el script de la aplicación en shiny.

#5 de agosto

He agregado unos cuadros adicionales (que no se generan en el app de shiny) y el script para obtenerlos (lac_graph.R)

© Copyright 2021 [Arturo Muente-Kunigami](https://www.twitter.com/n0wh3r3m4n).
