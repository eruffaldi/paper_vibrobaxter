topics:      /demonstrator                                 6 msgs    : vib_haptic_device/User_dem
             /hb_6/message_type                            1 msg     : std_msgs/String
             /manipulability_index                      1527 msgs    : std_msgs/Float64
             /robot/end_effector/left_gripper/state     1572 msgs    : baxter_core_msgs/EndEffectorState
             /robot/end_effector/right_gripper/state    1570 msgs    : baxter_core_msgs/EndEffectorState
             /robot/joint_states                        7939 msgs    : sensor_msgs/JointState
             /robot/limb/left/endpoint_state            7941 msgs    : baxter_core_msgs/EndpointState
             /robot/limb/right/endpoint_state           7940 msgs    : baxter_core_msgs/EndpointState
             /robot/state                               7940 msgs    : baxter_core_msgs/AssemblyState
             /rosout                                      74 msgs    : rosgraph_msgs/Log                 (20 connections)
             /tf                                       14091 msgs    : tf2_msgs/TFMessage                (2 connections)


/demonstrator == nome
/hb_6/message_type == messaggi al braccialetto
/manipulability_index
/robot/end_effector/left_gripper/state == secondo Baxter baxter_core_msgs/EndEffectorState
      http://api.rethinkrobotics.com/baxter_core_msgs/html/msg/EndEffectorState.html
/robot/limb/left/endpoint_state
      http://api.rethinkrobotics.com/baxter_core_msgs/html/msg/EndEffectorState.html
/robot/state
      http://api.rethinkrobotics.com/baxter_core_msgs/html/msg/AssemblyState.html

------

error = quanto tempo (assoluto o %) sto in uno dei livelli (L+H o H)
alt_error = numero di attivazioni:  factor x level = singolarita/manip x L/H

y = task duration
p = soggetto-indice + gruppo
x = sessione relativa (prima/seconda) 

1) verifica se la sessione relativa fa differenza

2) se task duration è influenzata da gruppo (prendendo la prima sessione e separatamente la seconda)

3) se error è influenzato dal gruppo