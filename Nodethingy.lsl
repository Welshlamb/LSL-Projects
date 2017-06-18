vector settings;
string bullet;
float fireDelay;
float maxSpread;
float recoil;
float spread;
float vel;
//float spreadHandler;
//float x;
//float y;
//float z;
//rotation rot;
key idSelf;
string fireSound;
list shotInfo;
list shotInfo2;
list shotInfo3;
key confirmQuery;
list objectDetails;
vector agentCheck;
integer objectShape;

default {
    on_rez(integer start) { 
        llResetScript();
    }
    
    state_entry() {
        llSetTimerEvent(0);
        llRequestPermissions(llGetOwner(), PERMISSION_TRACK_CAMERA);
        //idSelf = llGetOwnerKey();
    }
    link_message(integer sender_num, integer number, string message, key id) {
        if(number == 1)
        {
            list nodeParams = llParseString2List(message, ["#"], []);
            //llOwnerSay(llDumpList2String(nodeParams,","));
            bullet = llList2String(nodeParams,0);
            spread = llList2Float(nodeParams,1);
            maxSpread = llList2Float(nodeParams,2);
            recoil = llList2Float(nodeParams,3);
            fireDelay = llList2Float(nodeParams,4);
            fireSound = llList2String(nodeParams,5);
            //ammoLeft = llList2Integer(nodeParams,6);
        }
    }
    changed(integer fire) {
        if(fire&CHANGED_COLOR)
        {
            settings = llGetColor(0);
            if(settings.z == 1)
            {
                vel = settings.x;
                llResetTime();
                float rezPause = (fireDelay / (float)(llGetInventoryNumber(INVENTORY_SCRIPT) - 1)) * (integer)llGetScriptName();//The cycle speed of the weapon / the number of node scripts * current node number.
                llSleep(0.0 + rezPause);
                llSetTimerEvent(fireDelay);
            }
            else
            {
                llResetTime(); llSetTimerEvent(0);
            }
        }
    }
    timer()
    {
        //spreadHandler = spread * DEG_TO_RAD;
        //x = (llFrand(0.5)-0.25)*spreadHandler;
        //y = (llFrand(0.5)-0.25)*spreadHandler;
        //z = (llFrand(0.5)-0.25)*spreadHandler;
        //rot = llEuler2Rot(<x,y,z>);
        llTriggerSound(fireSound,1);
        //llRezAtRoot(bullet,(llGetCameraPos()+(llGetVel()*.2))+<5.5,0,0>*llGetCameraRot(),<settings.x,0,0>*llGetCameraRot()*rot, llEuler2Rot(<0, -90, 0>*DEG_TO_RAD)*llGetCameraRot()*rot, 1);
        shotInfo = llCastRay(llGetCameraPos()+<0,0,0>*llGetCameraRot(),llGetCameraPos()+<200,0,0>*llGetCameraRot(),[RC_REJECT_TYPES,RC_REJECT_PHYSICAL]);
        /*string shotCheck = llDumpList2String(shotInfo," | ");
        llOwnerSay(shotCheck);*/
        confirmQuery = llList2Key(shotInfo,0);
        agentCheck = llGetAgentSize(confirmQuery);
        if(agentCheck != ZERO_VECTOR)
        {
            string targetName = llKey2Name(llList2Key(shotInfo,0));
            llOwnerSay("Targetted: "+targetName);
            integer convert = (integer)("0x"+llGetSubString(confirmQuery,0,8));
            llOwnerSay((string)convert);
        }
                 //if(spread < maxSpread)spread+=recoil;
        //if(llGetRegionTimeDilation() < .9)llSetTimerEvent(llGetRegionTimeDilation()*fireDelay);
        llMessageLinked(LINK_THIS,2,"ammo",NULL_KEY);
    }
}
