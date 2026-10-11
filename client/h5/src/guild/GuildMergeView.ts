import { BaseView1 } from '../common/BaseView1';
import { CookieWrapper } from '../common/CookieWrapper';
import { EventName } from '../common/EventName';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { RedDotController } from '../common/RedDotController';
import { RedKey } from '../common/RedDotDefine';
import { GuildEvent, GuildModel, IGuildMergeInfo } from '../commonModel/GuildModel';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { GameResPath } from '../util/GameResPath';
import { Util } from '../util/Util';
import { GuildMergeItem } from './GuildMergeItem';
export class GuildMergeView extends BaseView1 {
    private loopMgr: LoopScrowViewMgr;
    private loopMgr2: LoopScrowViewMgr;
    private model: GuildModel;
    is_center = true;
    destroy_imm = true;
    use_background = true;
    click_bg_toClose = true;
    show_open_movie = true;
    nowTab = 1;
    guild_list_
    guild_list: ({ guild_id: number; guild_name: string; guild_lv: number; guild_exp: number; chief_id: number; chief_name: string; member_num: number; member_capacity: number; is_apply: number; auto_approve_power: number; combat_power: number; merge_status: number; is_master: number } & { tabIndex: number })[];
    public constructor() {
        super();
        this.base_file = 'guild';
        this.layout_file = 'GuildMergeView';
        this.layer_value = Enum_UILayer.Activity;
        this.model = GuildModel.GetInstance();
        this.click_bg_toClose = true
        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();
        };
        this.open_callback = () => {
            this.model.Fire(GuildEvent.REQUEST_PROTO, 40001, 'shh', '', 999, 1);
        };
        this.destroy_callback = () => {
            if (this.loopMgr) {
                this.loopMgr.DeleteMe();
                this.loopMgr = null
            }


            if (this.loopMgr2) {
                this.loopMgr2.DeleteMe();
                this.loopMgr2 = null
            }

            this.ChangeTab(1, true);
        };
    }
    LoadSuccess() {

        this.CheckMergeGuide();
    }
    InitEvent() {
        //this.UpdateView.bind(this) bind方法返回一个新的函数，this：新方法使用对象
        this.BindEvent(this.model, GuildEvent.UPDATE_JION_LIST, (guild_list) => {
            this.UpdateView(guild_list, 1)
        });
        this.BindEvent(this.model, GuildEvent.UPDATE_MERGE_VIEW, (guild_list) => {
            this.UpdateView(guild_list, 2)
        });
        this.BindEvent(this.model, GuildEvent.MERGE_APPLY, (guild_id, op) => {
            this.UpdateList(guild_id, op,this.nowTab)
        });
        Util.AddClickEvent(this.btnRequest, () => {
            this.ChangeTab(1, false)
        }, this, true);
        Util.AddClickEvent(this.btnApply, () => {
            this.ChangeTab(2, false)
        }, this, true);
        Util.AddClickEvent(this.btnClose, () => {
            this.Close()
        }, this, true);
        Util.AddClickEvent(this.btnHelp, () => {
            this.OnHelpClick()
        }, this, true);

        RedDotController.ins.bind(RedKey.GUILD_MERGE_APPLY, this.imgRed);
    }
    UpdateView(guild_list: IGuildMergeInfo[], tab_index) {
        if(this.nowTab!=tab_index)return
        for (let i = 0, len = Math.min(guild_list.length, 3); i < len; i++) {
            guild_list[i].isTop = true;
        }
        this.guild_list = guild_list.filter((guild) => guild.guild_id != this.model.GetGuildInfo().guild_id).map((guild) => Object.assign(guild, { tabIndex: this.nowTab }));
        let showList = guild_list.length > 0;
        this.noList.visible = !showList;
        this.mergeList.visible = showList;
        if (showList) {
            this.RenderList(this.guild_list)
        }
    }
    UpdateList(guild_id, op,tab_index) {
        let guild_list = this.guild_list;
        switch (op) {
            case 0:
                let guild = guild_list.find((guild) => guild.guild_id == guild_id);
                if (guild) {
                    guild.merge_status = 1;
                }
                break;
            case 1:
                // 服务器会主动推送公会信息，关闭界面就行
                RedDotController.ins.up(RedKey.GUILD_MERGE_APPLY, 0);
                this.Close();
                return;
            case 2:
                let id = guild_list.findIndex((guild) => guild.guild_id == guild_id);
                guild_list.splice(id, 1);
                RedDotController.ins.up(RedKey.GUILD_MERGE_APPLY, guild_list.length > 0 && this.model.GetGuildInfo()?.is_in_merge === 0);
                break;
        }

        if(this.nowTab!=tab_index)return //页签对不上，回滚
        let showList = guild_list.length > 0;
        this.noList.visible = !showList;
        if (showList) {
            this.RenderList(this.guild_list)
        }
    }

    RenderList(list) {
        if (!this.loopMgr) {
            this.loopMgr = new LoopScrowViewMgr();
            this.loopMgr.SetData(this.mergeList, GuildMergeItem, list, LoopScrCon.Vertical);
        } else {
            this.loopMgr.replaceAll(list);
        }
    }

    ChangeTab(tabIndex, force) {
        if (!force && tabIndex == this.nowTab) return;
        switch (tabIndex) {
            case 1:
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40001, 'shh', '', 999, 1);
                this.btnApply.skin = GameResPath.GetIcon('guild', 'ui_button_mid_1');
                this.btnRequest.skin = GameResPath.GetIcon('guild', 'ui_button_rect5');
                this.lblRequest.color = '#9b572f';
                this.lblApply.color = '#ffffff';
                break;
            case 2:
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40061);
                this.btnApply.skin = GameResPath.GetIcon('guild', 'ui_button_rect5');
                this.btnRequest.skin = GameResPath.GetIcon('guild', 'ui_button_mid_1');
                this.lblRequest.color = '#ffffff';
                this.lblApply.color = '#9b572f';
        }
        this.nowTab = tabIndex;
    }
    CheckMergeGuide() {
        if (!GuildModel.IsGuildMaster() || !GuildModel.IsMergeOpen() || CookieWrapper.GetInstance().GetCookie(CookieWrapper.GUILD_MERGE_GUIDE, true)) {
            return;
        }
        let step_cfg = { direction: 2, text: '点击了解结社合并详细规则~', effect_scaleX: 0.3, effect_scaleY: 0.3, close_time: 10 };
        GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.btnHelp, Enum_UILayer.UI, 0, 0, null, null, step_cfg, true);
    }
    OnHelpClick() {
        // 公会帮助
        GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.btnHelp);
        GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 4001);
        CookieWrapper.GetInstance().SaveCookie(CookieWrapper.GUILD_MERGE_GUIDE, 'true', true);
        // setCookie
    }


    btnClose: Laya.Image
    btnRequest: Laya.Image
    lblRequest: Laya.Label
    btnApply: Laya.Image
    lblApply: Laya.Label
    imgRed: Laya.Image
    btnHelp: Laya.Image
    mergeList: Laya.List
    noList: Laya.Box
    public GetComponents() {
        [
            this.btnClose,
            this.btnRequest,
            this.lblRequest,
            this.btnApply,
            this.lblApply,
            this.imgRed,
            this.btnHelp,
            this.mergeList,
            this.noList,
        ]
            = this.GetChildrenByNames([

                "btnClose",
                "btnRequest",
                "lblRequest",
                "btnApply",
                "lblApply",
                "imgRed",
                "btnHelp",
                "mergeList",
                "noList",
            ])
    }
}
window["GuildMergeView"] = GuildMergeView