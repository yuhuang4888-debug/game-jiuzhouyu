import { HtmlColorTxt, Util } from './../util/Util';
import { GhostWalkModel, GhostWalkEvent } from './../commonModel/GhostWalkModel';
import { Enum_UILayer } from './../common/LayerManager';
import { BaseItem1 } from '../common/BaseItem1';
import { kfStageModel } from '../commonModel/kfStageModel';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventName } from '../common/EventName';
import { Alert, Alert_Type } from '../alert/Alert';
import { ResManager } from '../common/ResManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { EquipmentItem } from '../common/EquipmentItem';
import { GoodsModel } from '../commonModel/GoodsModel';
import { CommonRewardItem } from '../common/CommonRewardItem';
import { GameResPath } from '../util/GameResPath';
import './GhostWalkShopView';
import './GhostWalkBossEntryView';
import './GhostWalkRewardView';
import './ghostWalkTeam/GhostWalkTeamView';
import { OpenFun } from '../common/OpenFun';

export class GhostWalkView extends BaseItem1 {
    loop_mgr: LoopScrowViewMgr;
    lastRewardItem: EquipmentItem;
    private _model: GhostWalkModel;
    cfg;
    public constructor(parent?) {
        super(parent);
        this.base_file = 'ghostWalk';
        this.layout_file = 'GhostWalkView';
        this.layer_value = Enum_UILayer.UI;
        this._model = GhostWalkModel.ins;
        this.load_callback = () => {
            this.initView();
            this.initEvent();
        };
    }

    private initView() {
        this.htmlMode.style.color = '#663915';
        this.htmlMode.style.fontSize = 20;
        this.htmlMode.style.wordWrap = false;
        this.htmlMode.innerHTML = '';
        this.htmlRuleDesc.y = 0;
        this.htmlRuleDesc.removeSelf();
        this.panelRule.addChild(this.htmlRuleDesc);
        this.panelRule.vScrollBarSkin = '';
        this.htmlRuleDesc.style.color = '#ffffff';
        this.htmlRuleDesc.style.fontSize = 20;
        this.htmlRuleDesc.style.wordWrap = true;
        // 规则说明
        let cfgInstruction = ResManager.GetInstance().GetGameConfigFromCache(this, 'ConfigInstruction', true);
        this.htmlRuleDesc.innerHTML = cfgInstruction[206][0].content.item_List[0].item_content[0].replace(/\n/g, '<br/>');
        this.htmlRuleDesc.width = 609;

        this.loop_mgr = new LoopScrowViewMgr();
        ResManager.GetInstance().SetOutsideImageSprite(this, this.imgBoss, GameResPath.GetIconOtherPath('ghostWalk', 'ui_bai_02'));
        ResManager.GetInstance().SetOutsideImageSprite(this, this.imgRewardBg, GameResPath.GetIconOtherPath('ghostWalk', 'ui_bai_03'));

        let fakeRewardList = this._model.getFakeRewardList(100);
        this.loop_mgr.SetData(this.listReward, CommonRewardItem, fakeRewardList, LoopScrCon.Horizontal, null, null, null, 100, 100);

        this._red_shop.visible = this._model.GetDayFirstLoginStatus()
    }

    private initEvent() {
        this.BindEvent(this._model, GhostWalkEvent.RecvFmt20601, this.SetModelInfo.bind(this));
        this._model.Fire(GhostWalkEvent.SendFmt20601);
        Util.AddClickEvent(
            this.btnShop,
            () => {
                this._red_shop.visible = false
                OpenFun.OpenFunHandler(246)
                // GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GhostWalkShopView');
            },
            this,
            true
        );
        Util.AddClickEvent(
            this.btnLast,
            () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GhostWalkRewardView');
            },
            this,
            true
        );
        Util.AddClickEvent(
            this.btnGo,
            () => {
                if (this._model.serInfo && this._model.serInfo.state == 0) {
                    // 活动未开启
                    Alert.Show('所有场景中未有boss入侵迹象，是否仍要进入？', Alert_Type.Two, () => {
                        GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GhostWalkBossEntryView');
                    });
                } else {
                    // 打开boss选择界面
                    GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GhostWalkBossEntryView');
                }
            },
            this,
            true
        );
        Util.AddClickEvent(
            this.btnTeam,
            () => {
                if (this._model.serInfo && this._model.serInfo.state == 0) {
                    // 活动未开启
                    Alert.Show('所有场景中未有boss入侵迹象，是否仍要进入？', Alert_Type.Two, () => {
                        GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GhostWalkTeamView');
                    });
                } else {
                    // 打开boss选择界面
                    GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GhostWalkTeamView');
                }
            },
            this,
            true
        );
        Util.AddClickEvent(
            this.btnProcess,
            () => {
                kfStageModel.GetInstance().OpenKfStageView(kfStageModel.FUNC_206);
            },
            this,
            true
        );
    }

    public SetModelInfo() {
        if (this._model.serInfo && this.is_loaded) {
            this.htmlMode.style.color = '#663915';
            this.htmlMode.style.fontSize = 20;
            this.htmlMode.style.wordWrap = false;//d15e00
            let ser_mod = `${(this._model.serInfo.ser_mod == 1 && '本') || this._model.serInfo.ser_mod}服模式`
            this.htmlMode.innerHTML = `当前模式：${HtmlColorTxt(ser_mod,'"#d15e00"')}`;
        }
    }

    public DeleteMe() {
      
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
        super.DeleteMe();
    }

imgRewardBg:Laya.Image
btnShop:Laya.Image
_red_shop:Laya.Image
btnLast:Laya.Image
imgBoss:Laya.Image
btnProcess:Laya.Image
lblProcess:Laya.Label
btnGo:Laya.Image
lblGo:Laya.Label
btnTeam:Laya.Image
lblTeam:Laya.Label
panelRule:Laya.Panel
htmlRuleDesc:Laya.HTMLDivElement
listReward:Laya.List
htmlMode:Laya.HTMLDivElement
public GetComponents() {
[
this.imgRewardBg,
this.btnShop,
this._red_shop,
this.btnLast,
this.imgBoss,
this.btnProcess,
this.lblProcess,
this.btnGo,
this.lblGo,
this.btnTeam,
this.lblTeam,
this.panelRule,
this.htmlRuleDesc,
this.listReward,
this.htmlMode,
]
 = this.GetChildrenByNames([

"imgRewardBg",
"btnShop",
"_red_shop",
"btnLast",
"imgBoss",
"btnProcess",
"lblProcess",
"btnGo",
"lblGo",
"btnTeam",
"lblTeam",
"panelRule",
"htmlRuleDesc",
"listReward",
"htmlMode",
])
}
}
 window["GhostWalkView"]= GhostWalkView