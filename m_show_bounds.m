function [p2,p3] = m_show_bounds(sd,hbsetup,td,I,man)
r2d = 180/pi;

rr = [];
rr.ps = cell2mat([td.ini_pick,td.end_pick,td.ini_place,td.end_place,td.ini_leave,td.end_leave]);
rr.cols = ['cckkmm'];
rr.sty = {'-','--','-','--','-','--'};
rr.name = {'Pick','','Place','','Leave',''};

if man == 1
sg = 0.0015;
p2=line([sd.time(1),sd.time(end)],[hbsetup.threshold_man(2),hbsetup.threshold_man(2)],'Color','green');
p3=line([sd.time(1),sd.time(end)],[hbsetup.threshold_man(1),hbsetup.threshold_man(1)],'Color','red');
%line([sd.time(1),sd.time(end)],[hbsetup.threshold_man(1)-sg,hbsetup.threshold_man(1)-sg],'Color',[.8,.8,.8],'LineWidth',5);
rectangle('Position',[sd.time(1),r2d*(hbsetup.threshold_man(1)),sd.time(end)-sd.time(1),r2d*sg],'FaceColor',[.8,.8,.8],'EdgeColor',[.8,.8,.8]);

else
r2d = 180/pi;
sg = 0.1;
p2=line([sd.time(1),sd.time(end)],r2d*[hbsetup.jointmax0L(I),hbsetup.jointmax0L(I)],'Color','green');
%line([sd.time(1),sd.time(end)],r2d*[hbsetup.jointmax0H(I)+sg,hbsetup.jointmax0H(I)+sg],'Color',[.8,.8,.8],'LineWidth',5);
rectangle('Position',[sd.time(1),r2d*(hbsetup.jointmax0H(I)),sd.time(end)-sd.time(1),r2d*sg],'FaceColor',[.8,.8,.8],'EdgeColor',[.8,.8,.8]);
p3=line([sd.time(1),sd.time(end)],r2d*[hbsetup.jointmax0H(I),hbsetup.jointmax0H(I)],'Color','red');

line([sd.time(1),sd.time(end)],r2d*[hbsetup.jointmin0L(I),hbsetup.jointmin0L(I)],'Color','green');
rectangle('Position',[sd.time(1),r2d*(hbsetup.jointmin0H(I)-sg),sd.time(end)-sd.time(1),r2d*sg],'FaceColor',[.8,.8,.8],'EdgeColor',[.8,.8,.8]);
line([sd.time(1),sd.time(end)],r2d*[hbsetup.jointmin0H(I),hbsetup.jointmin0H(I)],'Color','red');
%line([sd.time(1),sd.time(end)],r2d*[hbsetup.jointmin0H(I)-sg,hbsetup.jointmin0H(I)-sg],'Color',[.8,.8,.8],'LineWidth',5);
end

yl = ylim;
for J=1:length(rr.ps)
    line([sd.time(rr.ps(J)),sd.time(rr.ps(J))],yl,'Color',rr.cols(J),'LineStyle',rr.sty{J});
    if(~isempty(rr.name{J}))
    text(sd.time(rr.ps(J)),mean(yl),rr.name{J});
    end
end