function data = processbag(f)
    data =[];

bag1 = ros.Bag.load(f);
    [msgs_joints, meta_joints] = bag1.readAll('/robot/joint_states');
    [msgs_left_grip, meta_left_grip] = bag1.readAll('/robot/end_effector/left_gripper/state');
    [msgs_eel, meta_eel] = bag1.readAll('/robot/limb/left/endpoint_state');
    [msgs_man, meta_man] = bag1.readAll('/manipulability_index');
    [msgs_mess, meta_mess] = bag1.readAll('/hb_6/message_type');
    msgs_messc = cellfun(@(x) x.data,msgs_mess,'UniformOutput',0);
    meta_messt = cellfun(@(x) x.time.time,meta_mess);
    msgs_messc = categorical(msgs_messc,        {'Singularity attention','Singularity alarm','Manipulability attention','Manipulability alarm'},{'SL','SH','ML','MH'});
    [msgs_dem, meta_dem] = bag1.readAll('/demonstrator');
    
for i=1:size(msgs_joints,2)
    joints(i).name = msgs_joints{i}.name';
    joints(i).pos = msgs_joints{i}.position';
    joints_time(i) = meta_joints{i}.time.time;
end

for i=1:size(msgs_eel,2)
    eel_pose(i).translation = msgs_eel{i}.pose.position';
    eel_pose(i).rotation = msgs_eel{i}.pose.orientation';
    eel_time(i) = meta_eel{i}.time.time;
end

for i=1:size(msgs_man,2)
    man_index(i).index = msgs_man{i};
    man_time(i) = meta_man{i}.time.time;
end

mess = [];
mess_time = [];
for i=1:size(msgs_mess,2)
    mess(i).data = msgs_mess{i}.data;
    mess_time(i) = meta_mess{i}.time.time;
end

for i=1:size(msgs_dem,2)
    dem(i).id = msgs_dem{i}.id_user;
    dem(i).type = msgs_dem{i}.pr_type;
    dem(i).exp = msgs_dem{i}.num_exp;
    dem(i).start = msgs_dem{i}.start;
    dem(i).stamp = msgs_dem{i}.stamp;
    dem_time(i) = meta_dem{i}.time.time;
end

%%
%interpolation
t_start = [joints_time(1), eel_time(1), man_time(1)];
t0 = max(t_start);
t_final = [joints_time(size(joints_time,2)), eel_time(size(eel_time,2)), man_time(size(man_time,2))];
tend = min(t_final);
xq = t0:0.05:tend;


%%
%joints interp for left arm (joints from 3 to 9)
for i=1:size(joints,2)
    jleft1(i) = joints(i).pos(3);
    jleft2(i) = joints(i).pos(4);
    jleft3(i) = joints(i).pos(5);
    jleft4(i) = joints(i).pos(6);
    jleft5(i) = joints(i).pos(7);
    jleft6(i) = joints(i).pos(8);
    jleft7(i) = joints(i).pos(9);
end
jleft1_int = interp1(joints_time,jleft1,xq,'pchip');
jleft2_int = interp1(joints_time,jleft2,xq,'pchip');
jleft3_int = interp1(joints_time,jleft3,xq,'pchip');
jleft4_int = interp1(joints_time,jleft4,xq,'pchip');
jleft5_int = interp1(joints_time,jleft5,xq,'pchip');
jleft6_int = interp1(joints_time,jleft6,xq,'pchip');
jleft7_int = interp1(joints_time,jleft7,xq,'pchip');
% figure
% plot(joints_time,jleft1,'ro',xq,jleft1_int);
% figure
% plot(joints_time,jleft2,'ro',xq,jleft2_int);
% figure
% plot(joints_time,jleft3,'ro',xq,jleft3_int);
% figure
% plot(joints_time,jleft4,'ro',xq,jleft4_int);
% figure
% plot(joints_time,jleft5,'ro',xq,jleft5_int);
% figure
% plot(joints_time,jleft6,'ro',xq,jleft6_int);
% figure
% plot(joints_time,jleft7,'ro',xq,jleft7_int);

%eel_pose interp
for i=1:size(eel_pose,2)
    eel_posx(i) = eel_pose(i).translation(1);
    eel_posy(i) = eel_pose(i).translation(2);
    eel_posz(i) = eel_pose(i).translation(3);
end
eel_posx_int = interp1(eel_time,eel_posx,xq,'pchip');
eel_posy_int = interp1(eel_time,eel_posy,xq,'pchip');
eel_posz_int = interp1(eel_time,eel_posz,xq,'pchip');

%manipulability interp
for i=1:size(man_index,2)
    man_index_i(i) = man_index(i).index;
end
man_index_int = interp1(man_time,man_index_i,xq,'pchip');

%%
xq_t = xq(:)-xq(1);

%%
%exp timing

%exp 1
% bck = dem(1).stamp.time;
% k1_ini = find(xq>=bck,1);
% bck = dem(2).stamp.time;
% k1_end = find(xq>=bck,1);

% %exp 2
% %pick
% bck = dem(3).stamp.time;
% k2_ini_pick = find(xq>=bck,1);
% bck = dem(4).stamp.time;
% k2_end_pick = find(xq>=bck,1);
% %place
% bck = dem(5).stamp.time;
% k2_ini_place = find(xq>=bck,1);
% bck = dem(6).stamp.time;
% k2_end_place = find(xq>=bck,1);
% %leave
% bck = dem(7).stamp.time;
% k2_ini_leave = find(xq>=bck,1);
% bck = dem(8).stamp.time;
% k2_end_leave = find(xq>=bck,1);

% %exp 3
% %pick
% bck = dem(9).stamp.time;
% k3_ini_pick = find(xq>=bck,1);
% bck = dem(10).stamp.time;
% k3_end_pick = find(xq>=bck,1);
% %place
% bck = dem(11).stamp.time;
% k3_ini_place = find(xq>=bck,1);
% bck = dem(12).stamp.time;
% k3_end_place = find(xq>=bck,1);
% %leave
% bck = dem(13).stamp.time;
% k3_ini_leave = find(xq>=bck,1);
% bck = dem(14).stamp.time;
% k3_end_leave = find(xq>=bck,1);
% 
% %exp 4
% %pick
% bck = dem(15).stamp.time;
% k4_ini_pick = find(xq>=bck,1);
% bck = dem(16).stamp.time;
% k4_end_pick = find(xq>=bck,1);
% %place
% bck = dem(17).stamp.time;
% k4_ini_place = find(xq>=bck,1);
% bck = dem(18).stamp.time;
% k4_end_place = find(xq>=bck,1);
% %leave
% bck = dem(19).stamp.time;
% k4_ini_leave = find(xq>=bck,1);
% bck = dem(20).stamp.time;
% k4_end_leave = find(xq>=bck,1);

%exp 21
%pick
bck = dem(1).stamp.time;
k2_ini_pick = find(xq>=bck,1);
bck = dem(2).stamp.time;
k2_end_pick = find(xq>=bck,1);
%place
bck = dem(3).stamp.time;
k2_ini_place = find(xq>=bck,1);
bck = dem(4).stamp.time;
k2_end_place = find(xq>=bck,1);
%leave
bck = dem(5).stamp.time;
k2_ini_leave = find(xq>=bck,1);
bck = dem(6).stamp.time;
k2_end_leave = find(xq>=bck,1);

%%
%messages timing
for i=1:size(mess,2)
    bck = mess_time(i);
    mess_index(i) = find(xq>=bck,1);
end

data.duration = tend-t0;
data.k2_ini_pick = k2_ini_pick;
data.k2_end_pick = k2_end_pick;
data.k2_ini_place = k2_ini_place;
data.k2_end_place = k2_end_place;
data.k2_ini_leave = k2_ini_leave;
data.k2_end_leave = k2_end_leave;
data.data = table();
data.data.time = xq_t(:);
data.data.man_index =man_index_int(:);

% we mark nearest point in time xq: for every time in msgs_messt find
% nearest point in xq
qpi = interp1(xq,1:length(xq),meta_messt,'nearest');
data.data.activation = nan(height(data.data),1);
data.data.activation(qpi) = msgs_messc;

W= zeros(length(xq),7);
W(:,1) = jleft1_int;
W(:,2) = jleft2_int;
W(:,3) = jleft3_int;
W(:,4) = jleft4_int;
W(:,5) = jleft5_int;
W(:,6) = jleft6_int;
W(:,7) = jleft7_int;

data.data.joints = W;
