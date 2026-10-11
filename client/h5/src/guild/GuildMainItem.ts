import { Alert, Alert_Type } from '../alert/Alert';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { EventName } from '../common/EventName';
import { ResManager } from '../common/ResManager';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { MainFunc } from '../commonModel/MainUIModel';
import { ShopEvent, ShopIndex, ShopModel } from '../commonModel/ShopModel';
import { RedPacketModel } from '../commonModel/RedPacketModel';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { Util } from '../util/Util';
import { PlatformManager } from '../PlatformManager';
import { OpenFun } from '../common/OpenFun';
import { Message } from '../sysInfo/SysInfoController';
import { CookieWrapper } from '../common/CookieWrapper';
import { Enum_UILayer } from '../common/LayerManager';
import { StoryModel } from '../commonModel/StoryModel';
import { RedDotController } from '../common/RedDotController';
import { RedKey } from '../common/RedDotDefine';
import { TaskModel, TaskTipType } from '../commonModel/TaskModel';

export class GuildMainItem extends BaseItemRenderer {
    data;
    model: GuildModel;
    red_model;
    inited = false;
    is_click_open_merge=false
    task_model: TaskModel
    public static width = 90;
    public static height = 100;
    public constructor() {
        super();

        this.model = GuildModel.GetInstance();
        this.red_model = RedPacketModel.GetInstance();
        this.task_model = TaskModel.GetInstance()
        this.base_file = 'guild';
        this.layout_file = 'GuildMainItem';
        this.Load();
    }

    public DeleteMe() {
        this.data = null;
        this.inited = false;
        super.DeleteMe();
    }
    /**捐赠支线引导 */
    public ShowTaskDonateArrow() {
        if(!this.task_model.IsHasBranchTask(TaskModel.GuildDonateTaskId)
        &&!this.task_model.IsHasBranchTask(TaskModel.GuildExchangeTaskId)){
            return
        }
        if (!this.task_model.IsAllStepFinish(TaskModel.GuildDonateTaskId)
        ||!this.task_model.IsAllStepFinish(TaskModel.GuildExchangeTaskId)) {
            this.model.Fire(GuildEvent.BRANCE_TASK_GUIDE,1, true);
        }
    }

    public InitEvent() {
        let clickFunc: Function;
        let redKey;
        switch (this.data.id) {
            case 1:
                clickFunc = this.ClickGift;
                redKey = RedKey.GUILD_GIFT;
                break;
            case 2:
                clickFunc = this.ClickDonate;
                break;
            case 3:
                clickFunc = this.ClickSkill;
                redKey = RedKey.GUILD_SKILL;
                break;
            case 4:
                this.ShowTaskDonateArrow()
                clickFunc = this.ChickDepot;
                redKey = RedKey.GUILD_EXCHANGE;
                break;
            case 5:
                clickFunc = this.ClickFire;
                redKey = RedKey.GUILD_EVENING;
                break;
            case 6:
                clickFunc = this.ClickExplore;
                break;
            case 7:
                clickFunc = this.ClickOther;
                break;
            case 8:
                clickFunc = this.ClickDisband;
                break;
            case 9:
                clickFunc = this.ClickRedPacket;
                redKey = RedKey.GUILD_REDPACKET;
                break;
            case 10:
                clickFunc = this.ClickGuard;
                redKey = RedKey.GUILD_GUARD;
                break;
            case 11: //善缘商店
                clickFunc = this.ClickShop;
                redKey = RedKey.GUILD_SHOP1;
                break;
            case 12:
                clickFunc = this.ClickIdol;
                redKey = RedKey.GUILD_IDOL;
                break;
            case 13:
                clickFunc = this.ClickMerge;
                if(GuildModel.IsGuildMaster()){
                redKey = RedKey.GUILD_MERGE;
                }
                break;
        }
        Util.AddClickEvent(
            this._img_icon,
            () => {
                if (!this.data) return;
                clickFunc.call(this);
            },
            this,
            true
        );
        redKey && RedDotController.ins.bind(redKey, this._reddot);



        this.is_click_open_merge =false
        this.BindVar(this.model, 'guild_info', () => {
            if(this.data&&this.data.id==13){
                this.WaitBackClickMerge()
            }
        });

    }

    public dataChanged() {
        if (!super.dataChanged()) return;
        this._lb_name.text = this.data.title;
        ResManager.GetInstance().SetImageSprite(this, this._img_icon, 'guild_asset', this.data.icon);
        this.CheckMergeGuide();
        if (!this.inited) {
            this.InitEvent();
            this.inited = true;
        }
    }

    CheckMergeGuide() {
        if(this.task_model.IsHasBranchTask(TaskModel.GuildDonateTaskId)
        &&!this.task_model.IsAllStepFinish(TaskModel.GuildDonateTaskId)){
            return
        }
        if(this.task_model.IsHasBranchTask(TaskModel.GuildExchangeTaskId)
        &&!this.task_model.IsAllStepFinish(TaskModel.GuildExchangeTaskId)){
            return
        }
        if (this.data.id != 13 || !GuildModel.IsGuildMaster() || !GuildModel.IsMergeOpen() || CookieWrapper.GetInstance().GetCookie(CookieWrapper.GUILD_MERGE_GUIDE, true)) {
            return;
        }
        let step_cfg = { direction: 2, text: '<font style="fontSize:22">邀请其他结社合并，强强联手！</font>', effect_scaleX: 0.5, effect_scaleY: 0.5, close_time: 10 };
        GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._img_icon, Enum_UILayer.UI, 0, 30, null, null, step_cfg, true);
        StoryModel.GetInstance().GetFinger(this, this._img_icon);
    }

    public ClickGift() {
        this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildGiftView');
    }

    public ClickDonate() {
        this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildDonateView');
    }

    public ClickFire() {
        GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'EveningMainBaseView');
    }

    public ClickSkill() {
        this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildSkillBaseView');
    }

    public ClickIdol() {
        this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildIdolBaseView');
    }

    public ChickDepot() {
        this.model.Fire(GuildEvent.BRANCE_TASK_GUIDE,1, false);
        this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildDepotBaseView',247);
    }

   
    public ClickMerge() {
        this.is_click_open_merge=true
        this.model.Fire(GuildEvent.REQUEST_PROTO, 40005);
    }

    public WaitBackClickMerge() {
        if(!this.is_click_open_merge)return
        this.is_click_open_merge=false
        if (!GuildModel.IsGuildMaster()) {
            Message.show('仅结社会长可进行公会合并操作~');
            return;
        }
        if (GuildModel.GetInstance().GetGuildInfo()?.is_in_merge == 1) {
            Message.show('结社已经在合并中');
            return;
        }
        this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildMergeView');
        GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._img_icon);
    }

    public ClickDisband() {
        Alert.Show(Util.StrToHTML("解散结社后自动遣散所有结社成员<br>解散结社后将保留<font color='#60aeff'>结社技能等级</font>、<font color='#ff9015'>结社头衔</font><br>但<font color='#a376ff'>结社贡献</font>、<font color='#ff9015'>仓库积分</font>将被清空<br>是否确定解散结社？"), Alert_Type.Two, () => {
            if (GuildModel.GetInstance().GetGuildInfo()?.is_in_merge == 1) {
                Message.show('结社在合并中，无法解散');
                return;
            }
            this.model.Fire(GuildEvent.REQUEST_PROTO, 40027);
        });
    }

    public ClickOther() {
        this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildJoinBaseView');
    }

    public ClickExplore() {
        OpenFun.OpenFunHandler(58);
    }

    public ClickRedPacket() {
        //this.red_model.Fire(RedPacketEvent.OPEN_VIEW, "RedPacketMainView")
        GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'RedPacketMainView');
    }

    public ClickGuard() {
        //let activity = DailyModel.GetInstance().GetAcCfg(402, 3, 1)
        //if (activity ) {
        //GlobalEventSystem:Fire(EventName.OPEN_VIEW, "GuildGuardBaseView", activity)
        //}
    }

    //声望商店
    public ClickShop() {
        if (PlatformManager.GetInstance().is_alpha) return;
        GlobalEventSystem.Fire(EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.Guild, null, 4);
    }

    _img_icon: Laya.Image;
    _lb_name: Laya.Label;
    _reddot: Laya.Image;
    public GetComponents() {
        [this._img_icon, this._lb_name, this._reddot] = this.GetChildrenByNames(['_img_icon', '_lb_name', '_reddot']);
    }
}
window['GuildMainItem'] = GuildMainItem;
