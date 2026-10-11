import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { ShopEvent, ShopModel } from '../commonModel/ShopModel';
import { Util } from '../util/Util';
import { Config } from "../common/Config"
import { BaseAwardItem } from '../common/BaseAwardItem';
import { GoodsModel } from '../commonModel/GoodsModel';
import { ColorUtil, Enum_ColorUtil_Dark } from '../util/ColorUtil';
import { ResManager } from '../common/ResManager';
import { GameResPath } from '../util/GameResPath';
import { ReincarnationModel } from './../commonModel/ReincarnationModel';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { ReincarnationDanItem } from './ReincarnationDanItem';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventName } from '../common/EventName';

export class ReincarnationDanTips extends BaseView1 {
    static _layout_file: string = "ReincarnationDanTips";

    private conf: any;
    private id: string;
    private _item: BaseAwardItem;
    private loop_mgr: LoopScrowViewMgr;
    private curGoodsId: number = 0;
    private costNum: number = 1

    public constructor() {
        super();

        this.base_file = 'reincarnation';
        this.layout_file = 'ReincarnationDanTips';
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;

        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        };

    }



    public InitEvent() {
        // 点击转职
        Util.AddClickEvent(
            this.upBtn,
            () => {
                GoodsModel.GetInstance().Fire(GoodsModel.REQUEST_CCMD_EVENT, 15050, "li", this.curGoodsId, this.costNum);
                this.Close();
                GlobalEventSystem.Fire(EventName.CLOSE_REINCARNATION_ENTER_VIEW)
            },
            this,
            true
        );
    }


    private LoadSuccess() {
        let res_mgr: ResManager = ResManager.GetInstance()
        res_mgr.SetOutsideImageSprite(this, this.bgImg, GameResPath.GetIcon("functionOpen", "ui_notice_01"));
        res_mgr.SetOutsideImageSprite(this, this.titleImg, GameResPath.GetIconOtherPath("reincarnation", "ui_task_67"));
        res_mgr.SetOutsideImageSprite(this, this.lineImg, GameResPath.GetIconOtherPath("reincarnation", "ui_task_69"));
        this.RenderViwe();
    }


    private RenderViwe() {
        this.conf = Config.PRELOAD_SERVER_CONFIG.config_reincarnation_cfg[this.id];
        this.RenderDan();
        this.RenderTask();

    }


    private RenderTask() {
        let tsak: any[] = ReincarnationModel.GetInstance().GetTurnTaskList((this.conf?.turn || 0) + 1);

        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(
                this.taskList,
                ReincarnationDanItem,
                tsak,
                LoopScrCon.Horizontal,
            );
        } else {
            this.loop_mgr.replaceAll(tsak);
        }
    }

    private RenderDan() {
        let goodsModel: GoodsModel = GoodsModel.GetInstance();
        if (!this._item) {
            this._item = new BaseAwardItem(this.iconBox);
            this._item.Load();
        }
        this._item.SetItemSize(128, 128);
        this._item.SetItembgVisible(false);
        if (!this.conf) {
            return;
        }
        let data: any = JSON.parse(this.conf.turn_cost)[0];
        let [type_id, lock] = goodsModel.GetMappingTypeId(data[0], data[1]);
        let goods_vo = goodsModel.GetGoodsBasicByTypeId(type_id)
        if (goods_vo) {
            this._item.SetData(goods_vo.type_id);
            this.iconNameLab.text = goods_vo.goods_name;
            let goodsNum: number = goodsModel.GetTypeGoodsNum(goods_vo.type_id)
            this.numLab.text = `${goodsNum}/${data[2]}`;
            let bool: boolean = goodsNum >= data[2];
            this.curGoodsId = goodsModel.GetOneGoodsByTypeId(goods_vo.type_id);
            this.costNum = data[2];
            let color: string = ColorUtil.GetReplaceChar((bool ? Enum_ColorUtil_Dark.GREEN : Enum_ColorUtil_Dark.GOLDEN));
            this.numLab.color = color;
            ResManager.GetInstance().SetOutsideImageSprite(this, this.iconImg, GameResPath.GetGoodsIconPath(goods_vo.goods_icon))
            this.upBtn.gray = !bool;
            this.upBtn.mouseEnabled = bool;
            this.redImg.visible = bool;
        }
    }





    public Open(...new_args) {
        [this.id] = [...new_args]
        super.Open();
    }

    public DeleteMe() {
        if (this._item) {
            this._item.DeleteMe();
            this._item = null;
        }
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
        super.DeleteMe();
    }

    bgImg: Laya.Image
    titleImg: Laya.Image
    iconBox: Laya.Box
    iconNameLab: Laya.Label
    lineImg: Laya.Image
    taskList: Laya.List
    upBtn: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    iconImg: Laya.Image
    numLab: Laya.Label
    redImg: Laya.Image
    public GetComponents() {
        [
            this.bgImg,
            this.titleImg,
            this.iconBox,
            this.iconNameLab,
            this.lineImg,
            this.taskList,
            this.upBtn,
            this._Image1,
            this.labelDisplay,
            this.iconImg,
            this.numLab,
            this.redImg,
        ]
            = this.GetChildrenByNames([

                "bgImg",
                "titleImg",
                "iconBox",
                "iconNameLab",
                "lineImg",
                "taskList",
                "upBtn",
                "_Image1",
                "labelDisplay",
                "iconImg",
                "numLab",
                "redImg",
            ])
    }
}
window["ReincarnationDanTips"] = ReincarnationDanTips