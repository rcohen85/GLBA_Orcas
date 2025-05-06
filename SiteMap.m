% Location of cabled hydrophone
hydro = [58.43501,-135.92297];

% Plot hydrophone location relative to the rest of the park
latLims = [57.9,59.2];
lonLims = [-137.3,-134.8];
figure(111),clf
h = geoscatter(hydro(1),hydro(2),100,'red','filled','pentagram');
geolimits(latLims,lonLims);
geobasemap topographic
t=h.Parent;
t.LatitudeLabel.String="";
t.LongitudeLabel.String="";
t.LongitudeAxis.TickLabelFormat = '-dd';
t.LatitudeAxis.TickLabelFormat = '-dd';

saveas(gcf,'P:\users\cohen_rebecca_rec297\CCB\GLBA_Orcas\Figures\SiteMap.png');
exportgraphics(gcf,'P:\users\cohen_rebecca_rec297\CCB\GLBA_Orcas\Figures\SiteMap.pdf','ContentType','vector');

% Plot wider NE Pacific region with Glacier Bay marked
polyLats = [57.9,57.9,59.2,59.2,57.9];
polyLons = [-137.4,-134.9,-134.9,-137.4,-137.4];
sitePoly = geopolyshape(polyLats,polyLons);
latLims = [47,73];
lonLims = [-174,-122];

figure(11),clf
h = geoplot(sitePoly,'FaceColor','none','EdgeColor','r','LineWidth',2)
geobasemap bluegreen
geolimits(latLims,lonLims);
text(65,-161,'Alaska','FontSize',30)
t=h.Parent;
t.LatitudeLabel.String="";
t.LongitudeLabel.String="";

saveas(gcf,'P:\users\cohen_rebecca_rec297\CCB\GLBA_Orcas\Figures\RegionMap.png');
exportgraphics(gcf,'P:\users\cohen_rebecca_rec297\CCB\GLBA_Orcas\Figures\RegionMap.pdf','ContentType','vector');

