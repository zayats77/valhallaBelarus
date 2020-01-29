FROM valhalla/docker:3.0.02
ENV MAP belarus-latest

# ADD http://download.geofabrik.de/europe/${MAP}.osm.pbf /data/${MAP}.osm.pbf
# #COPY car.lua /opt/car.lua
# RUN osrm-extract -p /opt/car.lua /data/${MAP}.osm.pbf
# RUN osrm-contract /data/${MAP}.osrm

# CMD osrm-routed /data/${MAP}.osrm  --max-matching-size 3000


#download some data and make tiles out of it
#NOTE: you can feed multiple extracts into pbfgraphbuilder
ADD http://download.geofabrik.de/europe/${MAP}.osm.pbf /data/${MAP}.osm.pbf
#get the config and setup
CMD mkdir -p valhalla_tiles
CMD valhalla_build_config --mjolnir-tile-dir ${PWD}/valhalla_tiles --mjolnir-tile-extract ${PWD}/valhalla_tiles.tar --mjolnir-timezone ${PWD}/valhalla_tiles/timezones.sqlite --mjolnir-admin ${PWD}/valhalla_tiles/admins.sqlite > valhalla.json
#build routing tiles
#TODO: run valhalla_build_admins?
CMD valhalla_build_tiles -c valhalla.json switzerland-latest.osm.pbf liechtenstein-latest.osm.pbf
#tar it up for running the server
CMD find valhalla_tiles | sort -n | tar cf valhalla_tiles.tar --no-recursion -T -

#grab the demos repo and open up the point and click routing sample
CMD git clone --depth=1 --recurse-submodules --single-branch --branch=gh-pages https://github.com/valhalla/demos.git

#NOTE: set the environment pulldown to 'localhost' to point it at your own server