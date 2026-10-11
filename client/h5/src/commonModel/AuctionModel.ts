import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { table } from "../common/table"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { Config } from "../common/Config"
import { MainUIModel } from "./MainUIModel"
import { MainUIChatView } from "../mainUI/MainUIChatView"

export let AuctionEvent = {
    REQUEST_PROTO : "AuctionEvent.REQUEST_PROTO",
    UDPATE_AINFO : "AuctionEvent.UDPATE_AINFO",
    UDPATE_AINFO_ONE : "AuctionEvent.UDPATE_AINFO_ONE",
    START_AUCTON : "AuctionEvent.SWA",
    UPDATE_ESTIMATE : "AuctionEvent.UPDATE_ESTIMATE",
    CHANGE_AUCTION_VIEW : "CHANGE_AUCTION_VIEW",
    UPDATE_RED_RECORD : "AuctionEvent.UPDATE_RED_RECORD",
    UPDATE_RECORD : "AuctionEvent.UPDATE_RECORD"
}
window["AuctionEvent"] = AuctionEvent
export class AuctionModel extends EventDispatcher {
    ClearAuctionDic
    ClearRedDic
    DeleteAuction
    GetAuctionInfo
    GetAuctonData
    GetGodPicByType
    GetHolySealData
    GetRedDicByType
    GetRedInfoByID
    GetStage2BgSource
    GetStage2StrokeColor
    Reset
    SetAuctionInfo
    SetEffectState
    SetRedInfo
    SetRedStatus
    is_game_start

    public static TYPE = {
        GUILD : 1, 
        WORLD : 2, 
        SeaHegemoney : 3
    }
    public constructor() {
        super()
		let local_Config = Config
        let ConfigHasDefaultValue = Config.ConfigHasDefaultValue

        this.is_game_start = true;
        let local_AuctionEvent = AuctionEvent
        let local_GlobalEventSystem = GlobalEventSystem
        let update_effect_event = ActivityIconManager.UPDATE_EFFECT
        let _auction_dic_ = []
        let _red_dic_ = []
        this.Reset = () => {
            _auction_dic_ = []
            _red_dic_ = []
        }

        this.SetAuctionInfo = (info?) => {
            // [ts2lua]_auction_dic_下标访问可能不正确
            _auction_dic_[info.auction_type] = info
            this.Fire(local_AuctionEvent.UDPATE_AINFO, info)
        }

        this.GetAuctionInfo = (type?) => {
            // [ts2lua]_auction_dic_下标访问可能不正确
            return _auction_dic_[type]
        }

        this.ClearAuctionDic = () => {
            for (let key in _auction_dic_) {

                // [ts2lua]_auction_dic_下标访问可能不正确
                let vo = _auction_dic_[key]
                // [ts2lua]_auction_dic_下标访问可能不正确
                _auction_dic_[key] = null
                this.Fire(local_AuctionEvent.UDPATE_AINFO, vo)
            }
        }

        this.SetRedInfo = (info?) => {
            // [ts2lua]_red_dic_下标访问可能不正确
            let dic = _red_dic_[info.auction_type] || {}
            // [ts2lua]_red_dic_下标访问可能不正确
            _red_dic_[info.auction_type] = dic
            // [ts2lua]dic下标访问可能不正确
            dic[info.module_id] = info
            this.Fire(local_AuctionEvent.UPDATE_ESTIMATE, info.auction_type)
        }

        this.GetRedInfoByID = (auction_type?, module_id?) => {
            // [ts2lua]_red_dic_下标访问可能不正确
            // [ts2lua]_red_dic_[auction_type]下标访问可能不正确
            return _red_dic_[auction_type][module_id]
        }

        this.GetRedDicByType = (type?) => {
            // [ts2lua]_red_dic_下标访问可能不正确
            return _red_dic_[type]
        }

        this.ClearRedDic = () => {
            _red_dic_ = []
        }

        this.DeleteAuction = (type?, goods_id?) => {
            let ainfo = this.GetAuctionInfo(type)
            if (!ainfo) {
                return
            }
            let dic = []
            for (let _tmpi in ainfo.goods_list) {
                var vo = ainfo.goods_list[_tmpi]
                // [ts2lua]dic下标访问可能不正确
                let num = dic[vo.module_id]
                // [ts2lua]dic下标访问可能不正确
                // [ts2lua]lua中0和空字符串也是true，此处num需要确认
                dic[vo.module_id] = (num && (num + 1) || (1))
            }
            let i = 0
            do {
                let vo = ainfo.goods_list[i]
                if (vo.goods_id == goods_id) {
                    table.splice(ainfo.goods_list, i + 1, 1)
                    // [ts2lua]dic下标访问可能不正确
                    if (dic[vo.module_id] == 1) {
                        // [ts2lua]_red_dic_下标访问可能不正确
                        // [ts2lua]_red_dic_下标访问可能不正确
                        // [ts2lua]_red_dic_[type]下标访问可能不正确
                        if (_red_dic_[type] && _red_dic_[type][vo.module_id]) {
                            // [ts2lua]_red_dic_下标访问可能不正确
                            // [ts2lua]_red_dic_[type]下标访问可能不正确
                            _red_dic_[type][vo.module_id] = null
                        }
                        this.Fire(local_AuctionEvent.UPDATE_ESTIMATE, type)
                    }
                    break
                }
                i = i + 1
            } while ((i < ainfo.goods_list.length))
            if (ainfo.goods_list.length <= 0) {
                // [ts2lua]_red_dic_下标访问可能不正确
                _red_dic_[type] = null
                this.Fire(local_AuctionEvent.UPDATE_ESTIMATE, type)
            }
            this.SetAuctionInfo(ainfo)
        }

        this.GetAuctonData = (cfg?, id?, wlv?) => {
            let idx = 1
            // [ts2lua]cfg下标访问可能不正确
            let data = cfg[idx + "@" + id]
            while ((data)) {
                if (data.wlv1 <= wlv && data.wlv2 >= wlv) {
                    return data
                } else {
                    idx = idx + 1
                    // [ts2lua]cfg下标访问可能不正确
                    data = cfg[idx + "@" + id]
                }
            }
        }

        this.GetGodPicByType = (gold_type?) => {
            if (gold_type == 1) {
                return "com_diamond"
            } else if (gold_type == 2) {
                return "com_bind_diamond"
            } else {
                return ""
            }
        }

        this.SetRedStatus = (active?) => {
            RedDotManager.GetInstance().SetRedStatus(ModuleType.AUCTON, 1, active)
            local_GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MarketBaseView", 4, active)
            MainUIModel.GetInstance().Fire(MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, MainUIChatView.red_index.market, active)
        }

        this.SetEffectState = (active?) => {
            //if (active ) {
            //local_GlobalEventSystem:Fire(update_effect_event, 151, "UI_1131", true, false, {x=25, y=-25}, 0.7)
            //}else{
            //local_GlobalEventSystem:Fire(update_effect_event, 151, "UI_1131", false, false)
            //}
        }
        this.GetStage2BgSource = (stage?) => {
            let source = ""
            if (0 == stage) {
                source = "uisy_014a"
            } else if (1 == stage) {
                source = "uisy_014b"
            } else if (2 == stage) {
                source = "uisy_014c"
            } else if (3 == stage) {
                source = "uisy_014d"
            } else if (4 == stage) {
                source = "uisy_014e"
            } else if (5 == stage) {
                source = "uisy_014f"
            } else if (6 == stage) {
                source = "uisy_014g"
            } else if (7 == stage) {
                source = "uisy_014g"
            }
            return source
        }

        this.GetStage2StrokeColor = (stage?) => {
            let color = "#ffffff"
            if (0 == stage) {
                color = "#8f56e"
            } else if (1 == stage) {
                color = "#687a3a"
            } else if (2 == stage) {
                color = "#396796"
            } else if (3 == stage) {
                color = "#6c3b95"
            } else if (4 == stage) {
                color = "#984821"
            } else if (5 == stage) {
                color = "#9e2a2a"
            } else if (6 == stage) {
                color = "#c02c57"
            } else if (7 == stage) {
                color = "#c02c57"
            }
            return color
        }

        //未知用处 屏蔽
        // this.GetHolySealData = (type_id?) => {
        //     return Config.Sealequip[type_id]
        // }

    }

    static Instance
    public static GetInstance() {

        if (!AuctionModel.Instance) {
            AuctionModel.Instance = new AuctionModel()
        }
        return AuctionModel.Instance
    }

}
window["AuctionModel"] = AuctionModel