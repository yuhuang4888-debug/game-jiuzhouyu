import { BaseController } from "../common/BaseController";
import { EventName } from "../common/EventName";
import { table } from "../common/table";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { AuctionModel, AuctionEvent } from "../commonModel/AuctionModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { TimeUtil } from "../util/TimeUtil";
import { Util } from "../util/Util";

export class AuctionController extends BaseController {
    InitEvent
    InitInfo
    model
    //require("game.proto.154.Require154")
    public constructor() {
        super()


        this.model = AuctionModel.GetInstance();
        let local_AuctionEvent = AuctionEvent
        let user_msg_adapter = UserMsgAdapter.GetInstance()
        this.InitEvent = () => {
            this.model.Bind(local_AuctionEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
                this.SendFmtToGame(id, fmt, ...new_args)
            }
            )
            GlobalEventSystem.Bind(EventName.GAME_START, () => {
                let delay_fun = () => {
                    this.model.Fire(local_AuctionEvent.REQUEST_PROTO, 15401, "iii", AuctionModel.TYPE.WORLD, 0, 0)
                }
                setTimeout(delay_fun, 3)
            }
            )
        }

        this.InitInfo = () => {
            let on15400 = () => {
                let scmd = user_msg_adapter.GetSCMD(15400)
            }

            let on15401 = () => {
                let scmd = user_msg_adapter.GetSCMD(15401)
                let cur_time = TimeUtil.getServerTime()
                this.model.SetRedStatus(false)
                this.model.SetEffectState(false)
                let check_red = true
                for (let _tmpi in scmd.goods_list) {
                    var vo = scmd.goods_list[_tmpi]
                    vo.auction_type = scmd.auction_type
                    if ((check_red && vo.start_time <= cur_time) && vo.time > cur_time) {
                        this.model.SetRedStatus(true)
                        this.model.SetEffectState(true)
                        check_red = false
                    }
                }
                this.model.SetAuctionInfo(scmd)
            }

            let on15402 = () => {
                let scmd = user_msg_adapter.GetSCMD(15402)
                let ainfo = this.model.GetAuctionInfo(scmd.auction_type)
                if (!ainfo) {
                    return
                }
                let data = null
                let i = 0
                do {
                    let vo = ainfo.goods_list[i]
                    if (vo.goods_id == scmd.goods_id) {
                        if (scmd.goods_status == 1) {
                            if (vo.now_price != scmd.now_price || vo.top_player_id == 0 && scmd.top_player_id != 0) {
                                this.SendFmtToGame(15407, "ii", vo.auction_type, vo.module_id)
                            }
                            vo.now_price = scmd.now_price
                            vo.next_price = scmd.next_price
                            vo.time = scmd.time
                            vo.top_player_id = scmd.top_player_id
                            vo.is_delay = scmd.is_delay
                            vo.auction_type = scmd.auction_type
                            data = vo
                        } else if (scmd.goods_status == 2) {
                            this.SendFmtToGame(15407, "ii", vo.auction_type, vo.module_id)
                            table.splice(ainfo.goods_list, i + 1, 1)
                            if (scmd.top_player_id == RoleManager.GetInstance().GetMainRoleId()) {
                                this.SendFmtToGame(15409)
                            }
                        }
                        break
                    }
                    i = i + 1
                } while ((i < ainfo.goods_list.length))
                this.model.SetAuctionInfo(ainfo)
                this.model.Fire(local_AuctionEvent.UDPATE_AINFO_ONE, scmd, data)
            }

            let on15403 = () => {
                let scmd = user_msg_adapter.GetSCMD(15403)
                if (scmd.res == 1) {
                    Message.show("竞拍成功")
                } else {
                    Util.ErrorCodeShow(scmd.res)
                }
            }

            let on15404 = () => {
                let scmd = user_msg_adapter.GetSCMD(15404)
            }

            let on15405 = () => {
                let scmd = user_msg_adapter.GetSCMD(15405)
            }

            let on15406 = () => {
                let scmd = user_msg_adapter.GetSCMD(15406)
            }

            let on15407 = () => {
                let scmd = user_msg_adapter.GetSCMD(15407)
                this.model.SetRedInfo(scmd)
            }

            let on15408 = () => {
                let scmd = user_msg_adapter.GetSCMD(15408)
                this.model.SetRedStatus(true)
                this.model.SetEffectState(true)
                this.model.Fire(local_AuctionEvent.START_AUCTON, scmd)
            }

            let on15409 = () => {
                let scmd = user_msg_adapter.GetSCMD(15409)
                this.model.Fire(local_AuctionEvent.UPDATE_RECORD, scmd)
            }

            let on15410 = () => {
                let scmd = user_msg_adapter.GetSCMD(15410)
                this.model.Fire(local_AuctionEvent.UPDATE_RED_RECORD, scmd)
            }

            let on15411 = () => {
                let scmd = user_msg_adapter.GetSCMD(15411)
                if (scmd.all_close == 1) {
                    this.model.SetRedStatus(false)
                    this.model.SetEffectState(false)
                    this.model.ClearRedDic()
                    this.model.ClearAuctionDic()
                }
            }

            this.RegisterProtocal(15400, on15400)
            this.RegisterProtocal(15401, on15401)
            this.RegisterProtocal(15402, on15402)
            this.RegisterProtocal(15403, on15403)
            this.RegisterProtocal(15404, on15404)
            this.RegisterProtocal(15405, on15405)
            this.RegisterProtocal(15406, on15406)
            this.RegisterProtocal(15407, on15407)
            this.RegisterProtocal(15408, on15408)
            this.RegisterProtocal(15409, on15409)
            this.RegisterProtocal(15410, on15410)
            this.RegisterProtocal(15411, on15411)
        }

        this.InitInfo()
        this.InitEvent()
    }
    static Instance
    public static GetInstance() {

        if (!AuctionController.Instance) {
            AuctionController.Instance = new AuctionController()
        }
        return AuctionController.Instance
    }
}

window["AuctionController"] = AuctionController