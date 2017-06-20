function J = m_jointnames(x)

if nargin == 1
    bag1 = ros.Bag.load('1_!gexp_no_brac_2_exp_brac/AleG_nb.bag');
    [msgs_joints, meta_joints] = bag1.readAll('/robot/joint_states');
    msg = msgs_joints{1};
    J = msg.name(3:9);
else   
   J = { 'left_e0',
    'left_e1',
    'left_s0',
    'left_s1',
    'left_w0',
    'left_w1',
    'left_w2'};
end;
