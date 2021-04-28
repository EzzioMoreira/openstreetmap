FROM overv/openstreetmap-tile-server:1.4.0
EXPOSE 80
# Set up environment
ENV TZ=America/Sao_Paulo
ENV ALLOW_CORS=enabled
ENV THREADS=32

# Step 1: remove all original style files
RUN rm -rf /home/renderer/src/openstreetmap-carto/*.mss
RUN rm -rf /home/renderer/src/openstreetmap-carto/project.mml

# Step 2: add our custom style files
ADD carto-style /home/renderer/src/openstreetmap-carto

# Step 3: recompile the stylesheet
RUN cd /home/renderer/src/openstreetmap-carto \
 && carto project.mml > mapnik.xml \
 && scripts/get-shapefiles.py

# Step 4: See https://github.com/Overv/openstreetmap-tile-server
ADD map-data/iceland.poly /data.poly
ADD map-data/iceland-latest.osm.pbf /data.osm.pbf