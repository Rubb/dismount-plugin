/*
The nPose scripts are licensed under the GPLv2 (http://www.gnu.org/licenses/gpl-2.0.txt), with the following addendum:

The nPose scripts are free to be copied, modified, and redistributed, subject to the following conditions:
    - If you distribute the nPose scripts, you must leave them full perms.
    - If you modify the nPose scripts and distribute the modifications, you must also make your modifications full perms.

"Full perms" means having the modify, copy, and transfer permissions enabled in Second Life and/or other virtual world platforms derived from Second Life (such as OpenSim).  If the platform should allow more fine-grained permissions, then "full perms" will mean the most permissive possible set of permissions allowed by the platform.
*/
//Modified to work with SCHMO(E) type lines.

integer seatupdate = 35353;
list seatAndAv;
integer dismount = -221;

list SeatedAvs(){ //returns the list of uuid's of seated AVs
    list avs=[];
    integer counter = llGetNumberOfPrims();
    while (llGetAgentSize(llGetLinkKey(counter)) != ZERO_VECTOR){
        avs += [llGetLinkKey(counter)];
        counter--;
    }    
    return avs;
}

default
{
    state_entry()
    {
    }

    link_message(integer sender_num, integer num, string str, key id){
        if (num == dismount){
            list tempList = llParseStringKeepNulls(str, ["~"], []);
            integer sitters = llGetListLength(tempList);
            integer n;
            llSleep(1.0);
            for (n=0; n<sitters; ++n){
                integer seat# = (integer)llList2String(tempList, n);
                integer index = llListFindList(seatAndAv, [(seat#)]);
                if (llListFindList(SeatedAvs(), [(key)llList2String(seatAndAv, index + 1)]) != -1){
                    //slave will be doing all unsits from now on... link message out to the slave
                    llMessageLinked(LINK_SET, -222, llList2String(seatAndAv, index + 1), NULL_KEY);
                }
            }
        }else if (num == seatupdate){
            integer seatcount;
            list seatsavailable = llParseStringKeepNulls(str, ["^"], []);
            integer stop = llGetListLength(seatsavailable)/8;
            seatAndAv = [];
            for (seatcount = 0; seatcount < stop; ++seatcount){
                integer seatNum = (integer)llGetSubString(llList2String(seatsavailable, (seatcount)*8), 4,-1);
                seatAndAv += [seatcount+1, llList2String(seatsavailable, (seatcount)*8+4)];
            }
        }
    }
}
