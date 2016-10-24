import os,sys
import scipy.io as sio
import pprint


def scangroup(path,group,usersid):	
	path = os.path.abspath(path)
	users = []
	for x in os.listdir(path):
		fp = os.path.join(path,x)
		if os.path.isfile(fp) == 0:
			continue
		username,condition = os.path.splitext(x)[0].split("_")
		hasbrac = condition == "yb"
		id = usersid.get(username,None)
		if id is None:
			id = len(usersid)+1
			usersid[username] = id			
		if group == "BN":
			relindex = hasbrac and 1 or 2
		else:
			relindex = hasbrac and 2 or 1
		session = dict(user=username,hasbracelet=hasbrac,bag=fp,group=group,relindex=relindex,userid=id)
		users.append(((username,relindex),session))
	users.sort(key=lambda x: x[0])
	return [u[1] for u in users]


usersid = dict()
gBN = scangroup("1_exp_brac_2_exp_no_brac","BN",usersid)
gNB = scangroup("1_exp_no_brac_2_exp_brac","NB",usersid)

g = gBN+gNB

pprint.pprint(g)
sio.savemat("users.mat",dict(users=g,usersid=usersid))