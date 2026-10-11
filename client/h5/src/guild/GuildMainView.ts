import { BaseItem1 } from '../common/BaseItem1';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { ResManager } from '../common/ResManager';
import { GuildModel, GuildEvent, GuildPermission } from '../commonModel/GuildModel';
import { Message } from '../sysInfo/SysInfoController';
import { Enum_ColorUtil_Dark } from '../util/ColorUtil';
import { GameResPath } from '../util/GameResPath';
import { Util, HtmlColorTxt, SetHtmlStyle } from '../util/Util';
import { GuildMainItem } from './GuildMainItem';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventName } from '../common/EventName';

import './GuildRenameView';
import '../guild/GuildMergeView';
import '../guild/GuildMergeItem';
import { TaskModel } from '../commonModel/TaskModel';

export class GuildMainView extends BaseItem1 {
    horizontalCenter = 0;
    y = 10;
    cfg = null;
    cfg_finish = false;
    can_board = false;
    preload_client_config = {
        ConfigGuild: false
    };
    preload_server_config = {
        config_guild_lv: false
    };
    loop_mgr: LoopScrowViewMgr;
    model: GuildModel;
    resMgr: ResManager;
    btnList: { id: number; title: string; icon: string }[];

    public constructor(parent?) {
        super(parent);

        //this.item_list = [];
        this.base_file = 'guild';
        this.layout_file = 'GuildMainView';
        this.model = GuildModel.GetInstance();
        this.resMgr = ResManager.GetInstance();
        this.load_callback = () => {
            this.InitConfig();
            this.InitView();
            this.InitItems();
            this.InitEvent();
            this.FireEvent();

            ResManager.GetInstance().SetImageSpriteTrans(this, this._img_jiejie_b, GameResPath.GetIcon('guild', 'com_title_bg_4'), true);
        };
    }

    public DeleteMe() {
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
        super.DeleteMe();
    }

    //this.preload_server_config = [Guildlv=false]

    InitConfig() {
        this.cfg = ResManager.GetInstance().GetGameConfigFromCache(this, 'ConfigGuild', true);
        // cfg = this.preload_client_config["ConfigGuild"]
        //if (this.use_delete_method ) {
        //lua_resM:DestroyAllReferenceRes(this.hashCode)
        //return
        //}
        this.cfg_finish = true;
        if (this.is_loaded) {
            this.InitItems();
        }
    }

    InitView() {}

    FireEvent() {
        this.model.Fire(GuildEvent.REQUEST_PROTO, 40005);
    }

    InitEvent() {
        Util.AddClickEvent(
            this._image_5,
            () => {
                Message.show('尊贵的会长，拥有至高无上的“拳腻”');
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._image_6,
            () => {
                Message.show('结社等级越高，可容纳成员上限越高');
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._image_7,
            () => {
                Message.show('结社等级提升的必要资源');
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._image_8,
            () => {
                Message.show('结社成员的总战力！');
            },
            this,
            true
        );
        let board_func = () => {
            let data = this.model.GetGuildInfo();
            if (!data) {
                return;
            }
            if (!this.can_board) {
                Message.show('没有修改权限');
                return;
            }
            this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildBoardView', data.announce);
        };

        Util.AddClickEvent(
            this._lb_board,
            () => {
                board_func();
            },
            this
        );
        Util.AddClickEvent(
            this._btn_up_guild,
            () => {
                Message.show('升级结社');
            },
            this,
            true
        );

        this.BindVar(this.model, 'guild_info', () => {
            this.UpdateView();
        });

        Util.AddClickEvent(
            this._btn_board,
            () => {
                board_func();
            },
            this,
            true
        );

        Util.AddClickEvent(
            this.btnChangeName,
            () => {
                if (!GuildModel.IsGuildMaster()) {
                    Message.show('仅会长可以修改结社名称');
                    return;
                }
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GuildRenameView');
            },
            this,
            true
        );

        this.BindVar(this.model, 'gfunds', () => {
            this._lb_money.innerHTML = String(this.model.GetFunds());
        });
        this.BindEvent(this.model, GuildEvent.RENAME_SUCCESS, (newName) => {
            this._lb_guildname.text = newName;
        });
        this.BindEvent(this.model, GuildEvent.BRANCE_TASK_GUIDE, (step?,boo?) => {
            if(step !=1)return
            if(boo){
                if(!this.story_model.GetFinger(this, this._box_arrow)){
                    this.ShowTaskDonateArrow()
                }
            }else{
                if(this.story_model.GetFinger(this, this._box_arrow)){
                    GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_arrow)  
                }
            }
        });
    }
    /**捐赠-兑换支线引导 */
    private ShowTaskDonateArrow() {
        if (!this.task_model.IsAllStepFinish(TaskModel.GuildDonateTaskId)
        ||!this.task_model.IsAllStepFinish(TaskModel.GuildExchangeTaskId)) {
            let step = this.task_model.GetBranchTaskCfg(TaskModel.GuildDonateTaskId, 1)
            if (step) {
                this.story_model.task_supplement_list["GuildDonateTaskId"] = 1
                GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_arrow, "Main", null, null, null, null, step, true)
            }else{
                step = this.task_model.GetBranchTaskCfg(TaskModel.GuildExchangeTaskId, 1)
                if (step) {
                    this.story_model.task_supplement_list["GuildDonateTaskId"] = 1
                    GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_arrow, "Main", null, null, null, null, step, true)
                }
            }
        }
    }

    UpdateView() {
        let data = this.model.GetGuildInfo();
        if (!data) {
            return;
        }
        this._lb_guildname.text = data.guild_name;
        this._lb_board.text = data.announce;
        this._lb_level.text = 'Lv.' + data.guild_lv;
        this._lb_power.text = `${data.combat_power}`;
        this._lb_member.text = data.member_num + '/' + data.member_capacity;
        let master_figure = this.model.GetTopMemberVo(1);
        // [ts2lua]lua中0和空字符串也是true，此处master_figure需要确认
        this._lb_mastername.text = master_figure?.name || '暂无';
        this.can_board = this.model.HasPermission(GuildPermission.MODIFY_TENET_AND_ANNOUNCE);
        this.SetMoney(data.gfunds, this.GetUpgradeMoney());
    }

    InitItems() {
        if (!this.cfg_finish || !this.cfg) {
            return;
        }
        this.btnList = Object.values<{ id: number; title: string; icon: string }>(this.cfg.main_func).filter((info) => {
            switch (Number(info.id)) {
                case 8:
                    return GuildModel.IsGuildMaster();
                case 13:
                    return GuildModel.IsMergeOpen();
                case 11:
                case 12:
                    return this.model.GuildIdolIsOpen();
                default:
                    return true;
            }
        });

        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(this._group_item, GuildMainItem, this.btnList, LoopScrCon.Vertical);
        } else {
            this.loop_mgr.replaceAll(this.btnList);
        }

        this._group_item.scrollBar.touchScrollEnable = false;
    }

    SetMoney(gfunds?, need?) {
        let str = HtmlColorTxt(gfunds, Enum_ColorUtil_Dark.GREEN);
        SetHtmlStyle(this._lb_money, { f: 18, c: '#5a1c20', ww: false, w: 160 });
        this._lb_money.innerHTML = Util.StrToHTML(` ${str}/${need}`);
    }

    GetUpgradeMoney() {
        let guild_info = this.model.GetGuildInfo();
        if (!guild_info) {
            return '-';
        }
        let Guildlv = this.resMgr.GetGameConfigFromCache(this, 'config_guild_lv', false);
        // [ts2lua]Guildlv下标访问可能不正确
        let cfg = Guildlv && Guildlv[guild_info.guild_lv];
        if (!cfg || !cfg.growth_val_limit) {
            return '已满级';
        }
        return cfg.growth_val_limit;
    }

    _img_jiejie_bg: Laya.Image
    _img_jiejie_b: Laya.Image
    _Image2: Laya.Image
_box_images:Laya.Box
    _image_1: Laya.Image
    _image_2: Laya.Image
    _image_3: Laya.Image
    _image_4: Laya.Image
    _image_5: Laya.Image
    _image_6: Laya.Image
    _image_7: Laya.Image
    _image_8: Laya.Image
    _img_title_bg: Laya.Image
    btnChangeName: Laya.Image
    _lb_mastername: Laya.Label
    _lb_member: Laya.Label
    _lb_money: Laya.HTMLDivElement
    _lb_power: Laya.Label
    _lb_level: Laya.Label
    _lb_guildname: Laya.Label
    _lb_board: Laya.Label
    _group_item: Laya.List
    _btn_board: Laya.Image
    _btn_up_guild: Laya.Box
    _btn_up_img: Laya.Image
    _box_arrow: Laya.Box
    public GetComponents() {
        [
            this._img_jiejie_bg,
            this._img_jiejie_b,
            this._Image2,
this._box_images,
            this._image_1,
            this._image_2,
            this._image_3,
            this._image_4,
            this._image_5,
            this._image_6,
            this._image_7,
            this._image_8,
            this._img_title_bg,
            this.btnChangeName,
            this._lb_mastername,
            this._lb_member,
            this._lb_money,
            this._lb_power,
            this._lb_level,
            this._lb_guildname,
            this._lb_board,
            this._group_item,
            this._btn_board,
            this._btn_up_guild,
            this._btn_up_img,
            this._box_arrow,
        ]
            = this.GetChildrenByNames([
                "_img_jiejie_bg",
                "_img_jiejie_b",
                "_Image2",
"_box_images",
                "_image_1",
                "_image_2",
                "_image_3",
                "_image_4",
                "_image_5",
                "_image_6",
                "_image_7",
                "_image_8",
                "_img_title_bg",
                "btnChangeName",
                "_lb_mastername",
                "_lb_member",
                "_lb_money",
                "_lb_power",
                "_lb_level",
                "_lb_guildname",
                "_lb_board",
                "_group_item",
                "_btn_board",
                "_btn_up_guild",
                "_btn_up_img",
                "_box_arrow",
            ])
    }
}
window["GuildMainView"] = GuildMainView