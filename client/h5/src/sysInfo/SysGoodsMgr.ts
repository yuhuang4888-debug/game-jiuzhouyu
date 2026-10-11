import { Runner } from "../util/Runner";
import { LayerManager, Enum_UILayer } from "../common/LayerManager";
import { ObjPool } from "../scene/ObjPool";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName } from "../common/EventName";
import { Util } from "../util/Util";
import { BaseWindowComponent } from "../common/BaseWindowComponent";
import { GoodsItem } from "./GoodsItem";
import { MessageItemState } from "./MessageItem";
import { HashObject } from "../common/BaseClass";
export class SysGoodsMgr extends HashObject {
    public static Instance: SysGoodsMgr;
    DeleteGoods;
    InitMgr;
    AppendGoods;
    TryShowMiniGoods;
    ShowMiniGoods;
    StartUpdate;
    RemoveUpdate;
    Update;
    ClearGoodsCache;
    ResetItem;
    GetGoodsItemState;
    wnd_list_length;
    static MessageSetting = {
        "max_show_count": 5,
        "max_cache_count": 200,
        "default_height": 500,
        "horizontalCenter": 0,
        "default_scale": 0.3,
        "life_cycle": 2,
        "once_move_dis": 95,
        "once_move_time": 0.3,
        "stay_time": 0,
        "once_move_y_dis": 95,
        "once_move_y_time": 0.1,
    };
    public constructor() {
        super();
        let local_SysGoodsMgr = SysGoodsMgr, RUNNER = Runner.GetInstance(), goods_cache_list_, //信息队列 
        goods_wnd_list_, //当前显示的item列表
        goods_pool_list_, goods_con_, newest_hashCode_, update_id_;
        this.DeleteGoods = (hashCode) => {
            let obj = goods_wnd_list_[hashCode];
            if (obj != null) {
                delete goods_wnd_list_[hashCode];
                goods_pool_list_.ReleaseObj(obj);
            }
        };
        this.InitMgr = () => {
            if (!goods_pool_list_)
                goods_pool_list_ = {};
            if (!goods_con_)
                goods_con_ = {};
            let msg_con = new Laya.Box();
            // msg_con.touchChildren = false;
            // msg_con.touchEnabled = false;
            msg_con.height = msg_con.width = 0;
            let layer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Top);
            msg_con.x = layer.width / 2;
			msg_con.centerX = 0
			msg_con.anchorX = 0.5
			msg_con.anchorY = 0.5
			msg_con.width = 720
            msg_con.mouseThrough = true
            // msg_con.horizontalCenter = 0;
            msg_con.y = local_SysGoodsMgr.MessageSetting.default_height;
            layer.addChild(msg_con);
            goods_pool_list_ = new ObjPool(local_SysGoodsMgr.MessageSetting.max_cache_count);
            goods_con_ = msg_con;
            GlobalEventSystem.Bind(EventName.CHANGE_CUR_VIEW_COUNT, () => {
                if (!Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW) && this.wnd_list_length() > 0) {
                    this.ResetItem();
                }
            });
        };
        this.AppendGoods = (goodsVo) => {
            if (!goods_cache_list_)
                goods_cache_list_ = [];
            if (goods_cache_list_.length > 0 || !this.GetGoodsItemState()) {
                if (goods_cache_list_.length > local_SysGoodsMgr.MessageSetting.max_cache_count) {
                    goods_cache_list_.shift();
                }
                goods_cache_list_.push(goodsVo);
                this.TryShowMiniGoods();
            }
            else {
                this.ShowMiniGoods(goodsVo);
            }
        };
        this.TryShowMiniGoods = () => {
            if (this.GetGoodsItemState()) {
                let goods = goods_cache_list_.shift();
                if (goods)
                    this.ShowMiniGoods(goods);
            }
        };
        this.ShowMiniGoods = (goodsVo) => {
            let obj: GoodsItem = goods_pool_list_.GetObjFreeList();
            if (!obj) {
                obj = new GoodsItem(goods_con_);
                obj.Load();
            }
            obj.ExcuteCallback(() => {
                obj.SetGoods(goodsVo);
            });
            if (!goods_wnd_list_)
                goods_wnd_list_ = {};
            for (let key in goods_wnd_list_) {
                let obj = goods_wnd_list_[key];
                if (obj)
                    obj.MoveState = true;
            }
            goods_wnd_list_[obj.hashCode] = obj;
            newest_hashCode_ = obj.hashCode;
            obj.ChangeState(MessageItemState.born);
            this.StartUpdate();
        };
        this.StartUpdate = () => {
            if (!update_id_)
                update_id_ = RUNNER.AddRunObj(this);
        };
        this.RemoveUpdate = () => {
            if (update_id_) {
                RUNNER.RemoveRunObj(update_id_);
                update_id_ = undefined;
            }
        };
        this.Update = (now_time, elapse_time) => {
            if (goods_wnd_list_) {
                let bool = false;
                for (let key in goods_wnd_list_) {
                    let obj = goods_wnd_list_[key];
                    if (obj) {
                        bool = true;
                        obj.Update(now_time, elapse_time);
                    }
                }
                if (!bool)
                    this.RemoveUpdate();
            }
        };
        this.ClearGoodsCache = () => {
            if (goods_cache_list_)
                goods_cache_list_.length = 0;
        };
        this.ResetItem = () => {
            if (goods_wnd_list_) {
                for (let key in goods_wnd_list_) {
                    let obj = goods_wnd_list_[key];
                    if (obj) {
                        obj.ChangeState(MessageItemState.death);
                    }
                }
            }
            this.ClearGoodsCache();
        };
        //判断是否可以继续添加item
        this.GetGoodsItemState = () => {
            if (!goods_wnd_list_
                || !newest_hashCode_
                || !goods_wnd_list_[newest_hashCode_]
                || goods_wnd_list_[newest_hashCode_].GetState() != MessageItemState.born)
                return true;
        };
        this.wnd_list_length = () => {
            let count = 0;
            for (let key in goods_wnd_list_) {
                let obj = goods_wnd_list_[key];
                count++;
            }
            return count;
        };
        this.InitMgr();
    }
    public static GetInstance() {
        if (!SysGoodsMgr.Instance) {
            SysGoodsMgr.Instance = new SysGoodsMgr();
        }
        return SysGoodsMgr.Instance;
    }
}

window["SysGoodsMgr"] = SysGoodsMgr