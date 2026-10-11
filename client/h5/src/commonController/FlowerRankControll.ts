import { BaseController } from "../common/BaseController";
import { EventName } from "../common/EventName";
import { FigureProtoVo } from "../common/FigureProtoVo";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { FlowerRankEvent, FlowerrankModel } from "../commonModel/FlowerRankModel";
import { FlowerRankEnterView } from "../flowerRank/FlowerRankEnterView";
import "../flowerRank/FlowerRankView"
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import "../flowerRank/FlowerRankRewardItem"
import "../flowerRank/FlowerRankRewardView"


export class FlowerRankControll extends BaseController{
    InitView
    flower_rank_view
    user_msg_adapter
    local_EventName
    local_GlobalEventSystem
    local_FlowerRankEvent
    model
    public constructor() {
        super()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()
        this.local_EventName = EventName
		this.local_GlobalEventSystem = GlobalEventSystem
        this.local_FlowerRankEvent = FlowerRankEvent
        this.model = FlowerrankModel.GetInstance()
        this.InitEvent()

    }

    private InitEvent(){
        let request_proto = (scmd_id, ...new_args)=> {
            let args = new_args
            if(scmd_id == 22403 || scmd_id == 22401){
                this.SendFmtToGame(scmd_id, "ih", args[0], args[1])
            } else if(scmd_id == 13015){
                this.SendFmtToGame(scmd_id, "hlh",args[0], args[1], args[2])
            }
        }
        this.model.Bind(this.local_FlowerRankEvent.REQUEST_PROTO, request_proto)

        // let On22401 = ()=>{
        //     let scmd = this.user_msg_adapter.GetSCMD(22401)
        //     this.model.SetFlowerRankData(scmd)
        // }

        let On22403 = ()=>{
            let scmd = this.user_msg_adapter.GetSCMD(22403)
            this.model.SetFlowerRankData(scmd)
        }

        // let On13015 = ()=>{
        //     let scmd
        //     scmd = {}
        //     scmd.server_id = this.ReadFmt("h")
        //     scmd.type_id = this.ReadFmt("h")
        //     scmd.role_id = this.ReadFmt("l")
        //     scmd.figure = []
        //     new FigureProtoVo().ReadFmt(scmd.figure);
        //     this.model.SetTopRoleFigure(scmd)
        // }

        // this.RegisterProtocal(22401, On22401)
        this.RegisterProtocal(22403, On22403)
        // this.RegisterProtocal(13015, On13015)
    }
}

window["FlowerRankControll"] = FlowerRankControll
