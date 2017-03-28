
%% Figure of motion
r2d = 180/pi;
if exist('sessions') == 0
    load('loaded');
end
mysetup('exportfig');
Jn = m_jointnames();
Js = names2struct(Jn,0);
load time_real_exp
tim = maketab(tim);
tim.hasbracelet = cell2mat(tim.hasbracelet);  % TODO more generic
tim.user = tim.Name;
tim.id = [];
tim.Name = [];

xsessions = join(sessions,tim,'Keys',{'user','hasbracelet'});
sid =9;
sd = xsessions.odata{sid};
td = xsessions(sid,:);
hbsetup.threshold_man

set(0,'defaultaxesfontname','Helvetica');
set(0,'defaulttextfontname','Helvetica');

set(0,'defaultaxesfontsize',16);
set(0,'defaulttextfontsize',16);


I=2; % joint left_e1
    figure(I)
    clf
    [p2,p3] = m_show_bounds(sd,hbsetup,td,I,0);
    hold on
    p1=plot(sd.time,r2d*sd.joints(:,I),'b');

    
    legend([p1,p2,p3],{'Joint','Attention','Alarm'},'Location','SouthWest');
    %title(sprintf('Joint %s',Jn{I}),'Interpreter', 'none');
    xlabel('Time (s)');
    ylabel('Joint (deg)');
    set(findall(gcf,'-property','FontSize'),'FontSize',16)
    set(gcf,'Position',[  440   413   493   385]);
    export_fig('pdf','-transparent','jointtrigger.pdf');
    
%%
figure(8)
r2d = 180/pi;
clf
colors ={'b','g--'};
sids=[9,10]
hbsetup.threshold_man
pp = [];
for I=1:length(sids)
    sid = sids(I);
sd = xsessions.odata{sid};
td = xsessions(sid,:);

pp(I)=plot(sd.time,sd.man_index,colors{I},'LineWidth',2);
hold on
[p2,p3] = m_show_bounds(sd,hbsetup,td,I,1);


end
legend([pp(1),pp(2),p2,p3],{'Manipulability Index (no HB)','Manipulability Index (with HB)','Attention','Alarm'},'Location','SouthWest');
xlabel('Time (s)');
ylabel('Manipulability Index');
ylim([0,0.14])
    set(findall(gcf,'-property','FontSize'),'FontSize',16)
    set(gcf,'Position',[  272   383   662   415]);
    export_fig('pdf','-transparent','../img/mantrigger.pdf');
    
    
%%
close all
% 2 groups with 4 variables
z = zeros(2,4);
ze = zeros(2,4);
w = {'man_act_L_pct','man_act_LH_pct','joints_act_L_pct','joints_act_LH_pct'};
b = {false,true};
for I=1:2
    ss = sessions(sessions.hasbracelet == b{I},:);
    height(ss)
    for J=1:length(w)
        m = mean(ss.(w{J}));
        s = std(ss.(w{J}));
        z(I,J) = m;
        ze(I,J) = s*1.96/sqrt(height(ss));
    end
end
h = barwitherr(z,ze);
legend(w,'Interpreter','none');
xlabel('Group (metric)');
ylabel('Value');
set(gca,'XTickLabels',{'Without HB','With HB'});
%export_fig('pdf','-transparent','../img/stats.pdf')


%%
% 2 groups with 4 variables
clf
z = zeros(2,4);
ze = zeros(2,4);
w = {'joints_maxdist','joints_mindist','joints_stddist','joints_meandist'};
b = {false,true};
for I=1:2
    ss = sessions(sessions.hasbracelet == b{I},:);
    height(ss)
    for J=1:length(w)
        m = mean(ss.(w{J}));
        s = std(ss.(w{J}));
        z(I,J) = m;
        ze(I,J) = s*1.96/sqrt(height(ss));
    end
end
h = barwitherr(z,ze);
legend(w,'Interpreter','none');
xlabel('Group (metric)');
ylabel('Value');
set(gca,'XTickLabels',{'Without HB','With HB'});
%export_fig('pdf','-transparent','../img/stats.pdf')
