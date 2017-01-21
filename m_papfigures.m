
%% Figure of motion
if exist('sessions') == 0
    load('loaded');
end
mysetup('exportfig');
Jn = m_jointnames();
Js = names2struct(Jn,0);
summary(sd)
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

%%
I=6; % joint left_w1
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
clf
p1=plot(sd.time,sd.man_index,'b','LineWidth',2);
hold on
[p2,p3] = m_show_bounds(sd,hbsetup,td,I,1);

legend([p1,p2,p3],{'Manipulability Index','Attention','Alarm'},'Location','SouthWest');
%title(sprintf('Man Index'));
xlabel('Time (s)');
ylabel('Manipulability Index');

    set(findall(gcf,'-property','FontSize'),'FontSize',16)
    set(gcf,'Position',[  440   413   493   385]);
    export_fig('pdf','-transparent','mantrigger.pdf');
    
    
    %%
    boxplot(