import { BaseItem1 } from '../common/BaseItem1';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { RedDotController } from '../common/RedDotController';
import { RedKey } from '../common/RedDotDefine';
import { GuildEvent, GuildModel, GuildPermission } from '../commonModel/GuildModel';
import { Message } from '../sysInfo/SysInfoController';
import { TimeUtil } from '../util/TimeUtil';
import { Util } from '../util/Util';
import { GuildMemberItem } from './GuildMemberItem';

export class GuildMemberView extends BaseItem1 {
    dependent_res = ['mainUI', 'guild'];
    preload_server_config = { config_guild_prestige: false };
    apply_click_time = 0;
    loop_mgr: LoopScrowViewMgr;
    model: GuildModel;

    public constructor(parent?) {
        super(parent);
        this.layer_value = Enum_UILayer.UI;
        this.base_file = 'guild';
        this.layout_file = 'GuildMemberView';
        this.model = GuildModel.GetInstance();
        this.load_callback = () => {
            this.UpdateView();
            this.InitEvent();
            this.FireEvent();
        };
    }

    public DeleteMe() {
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
        super.DeleteMe();
    }
    FireEvent() {
        this.model.Fire(GuildEvent.REQUEST_PROTO, 40006);
    }

    InitEvent() {
        Util.AddClickEvent(
            this._btn_set,
            () => {
                if (!this.model.HasPermission(GuildPermission.APPROVE_SETTING)) {
                    Message.show('您没有操作权限');
                    return;
                }
                this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildApplySetView');
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_apply,
            () => {
                if (!this.model.HasPermission(GuildPermission.APPROVE_APPLY)) {
                    Message.show('您没有操作权限');
                    return;
                }
                if (this.model.apply_request_mark) {
                    return;
                }
                let time = TimeUtil.getServerTime();
                let c = this.apply_click_time;
                if (TimeUtil.getServerTime() - this.apply_click_time > 5) {
                    this.model.apply_request_mark = true;
                    this.apply_click_time = TimeUtil.getServerTime();
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40008);
                } else {
                    let apply_info = this.model.GetApplyInfo();
                    if (apply_info && apply_info.apply_list.length > 0) {
                        this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildApplyLookView');
                    }
                }
            },
            this,
            true
        );

        this.BindVar(this.model, 'member_info', () => {
            this.UpdateView();
        });

        RedDotController.ins.bind(RedKey.GUILD_APPLY, this.red);

        //this._scroller.addEventListener(Laya.UIEvent.CHANGE_START, this.StartScroll, this)
    }

    StartScroll() {
        //model:Fire(local_GuildEvent.CLOSE_ROLE_MENU_VIEW)
    }

    UpdateView() {
        let member_info = this.model.GetMemberInfo();
        if (!member_info) {
            return;
        }

        // let list = member_info.member_list
        // let arr_1=[]
        // for(let i=0;i<20;i++){
        // 	arr_1.push(list[0])
        // }

        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(this._list_menber, GuildMemberItem, member_info.member_list, LoopScrCon.Vertical);
        } else {
            this.loop_mgr.replaceAll(member_info.member_list);
        }
    }

    _Image3: Laya.Image;
    _list_menber: Laya.List;
    _Group2: Laya.Box;
    _btn_set: Laya.Box;
    _Image1: Laya.Image;
    labelDisplay1: Laya.Label;
    _btn_apply: Laya.Box;
    _Image11: Laya.Image;
    labelDisplay: Laya.Label;
    red: Laya.Image;
    public GetComponents() {
        [this._Image3, this._list_menber, this._Group2, this._btn_set, this._Image1, this.labelDisplay1, this._btn_apply, this._Image11, this.labelDisplay, this.red] = this.GetChildrenByNames(['_Image3', '_list_menber', '_Group2', '_btn_set', '_Image1', 'labelDisplay1', '_btn_apply', '_Image11', 'labelDisplay', 'red']);
    }
}

window['GuildMemberView'] = GuildMemberView;
