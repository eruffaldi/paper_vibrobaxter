%
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


%% Joints
% pick joint + attention and alarm limit
r2d = 180/pi;
for I=1:7
    figure(I)
    clf
    p1=plot(sd.time,r2d*sd.joints(:,I),'b');
    hold on
    [p2,p3] = m_show_bounds(sd,hbsetup,td,I,0);

    hold on
    p4 = plot(sd.time,sd.activation,'m*')
    legend([p1,p2,p3],{'Joint','Attention','Alarm'});
    title(sprintf('Joint %s',Jn{I}),'Interpreter', 'none');
    xlabel('Time (s)');
    ylabel('Joint (deg)');
    set(findall(gcf,'-property','FontSize'),'FontSize',16)
end


%% Manipulability
% pick joint + attention and alarm limit
figure(8)
clf
p1=plot(sd.time,sd.man_index,'b*');
hold on
[p2,p3] = m_show_bounds(sd,hbsetup,td,I,1);

legend([p1,p2,p3],{'Manipulability Index','Attention','Alarm'});
title(sprintf('Man Index'));
xlabel('Time (s)');
ylabel('Manipulability Index');

set(findall(gcf,'-property','FontSize'),'FontSize',12)