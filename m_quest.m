%%
load('questdata');
BaxterVibroPostQuestionnaire = BaxterVibroPostQuestionnaire(2:end,:);
%%
mysetup('exportfig');

%%
titles = {'Mental demand','Physical demand','Performance','Easiness of use','Learn quickly','Confidence'};
ds = table2array(BaxterVibroPostQuestionnaire);
clf
zm = mean(ds,1);
zs = std(ds,1);
bar(zm,'facecolor',[.8 .8 .8]); hold on;
errorb(zm,zs);
set(gca,'XTickLabels',titles);
rotateticklabel(gca,30);
set(gca,'position',[0.1 0.15 0.85 0.75])
ylabel('Likert scale (1-5)');
export_fig('pdf','-transparent','likert.pdf');