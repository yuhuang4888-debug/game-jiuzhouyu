import { BaseItem1 } from '../common/BaseItem1';
import { EventName } from '../common/EventName';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { table } from '../common/table';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { MainFunc } from '../commonModel/MainUIModel';
import { TaskModel, TaskTipType } from '../commonModel/TaskModel';
import { RoleManager } from '../commonModel/RoleManager';
import { Message } from '../sysInfo/SysInfoController';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { Util } from '../util/Util';
import { GuildJoinItem } from './GuildJoinItem';
import { BaseWindowComponent } from '../common/BaseWindowComponent';

export class GuildJoinView extends BaseItem1 {
    loop_mgr;
    model;
    story_obj_list;
    data_list: ProtoRecvVObj<40001>['guild_list'];

    public constructor(parent?) {
        super(parent);

        this.model = GuildModel.GetInstance();
        this.base_file = 'guild';
        this.layout_file = 'GuildJoinView';
        this.load_callback = () => {
            this.LoadSuccess();
            //GlobalEventSystem:Fire(EventName.SELECT_STORY_TARGET, StoryModel.StoryTargetName.GuildIcon, false)
        };
    }

    SortFunc() {}

    public createChildren() {
        this.story_obj_list = this.story_obj_list || {};
        // [ts2lua]this.story_obj_list下标访问可能不正确
        this.story_obj_list[TaskTipType.JoinGuild] = [this._btn_apply];
        super.createChildren();
    }

    public DeleteMe() {
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
        
        // this.model.apply_red_mark = true;
        // this.model.Fire(GuildEvent.UPDATE_BASE_RED_STATUS);
        // GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
        super.DeleteMe();
    }

    LoadSuccess() {
        if (this.task_model.MainTaskIsJoinGuildTaskType()) {
            let main_line_vo = this.task_model.GetMainLineTaskVo();
            if (main_line_vo && !this.task_model.IsAllStepFinish(main_line_vo.task_id)) {
                this.task_model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30008);
            }
        }

        this.InitEvent();
        this.FireEvent();
    }

    FireEvent() {
        this.model.Fire(GuildEvent.REQUEST_PROTO, 40001, 'shh', '', 999, 1);
    }

    InitEvent() {
        Util.AddClickEvent(
            this._btn_build,
            () => {
                if (GuildModel.IsHasGuild()) {
                    Message.show('您当前已有所属结社');
                    return;
                }
                this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildBuildView');
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_apply,
            () => {
                if (GuildModel.IsHasGuild()) {
                    Message.show('您当前已有所属结社');
                    return;
                }
                if (!this.data_list || this.data_list.length < 1) {
                    Message.show('暂无结社');
                    return;
                }
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40003);
                let task = TaskModel.GetInstance().GetMainLineTaskVo();
                if (task && task.task_id == 101080) {
                    let view = BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT;
                    if (view) {
                        view.Close();
                    }
                }
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_tips,
            () => {
                if (GuildModel.IsHasGuild()) {
                    Message.show('您当前已有所属结社');
                    return;
                }
                this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildBuildView');
            },
            this,
            true
        );
        this.BindEvent(this.model, GuildEvent.UPDATE_JION_LIST, (list?) => {
            this.data_list = list;
            this.UpdateView(list);
        });
        this.BindEvent(this.model, GuildEvent.APPLY_APPROVE, (guild_id?) => {
            if (!this.data_list) {
                return;
            }
            for (let _tmpi in this.data_list) {
                var info = this.data_list[_tmpi];
                if (info.guild_id == guild_id) {
                    info.is_apply = 1;
                    break;
                }
            }
            this.UpdateView(this.data_list);
        });
        // this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), 'guild_id', (type?, value?, old_value?) => {
        //     if (old_value == 0) {
        //         this._reddot.visible = false;
        //         this.create_reddot.visible = false;
        //         this.model.apply_red_mark = true;
        //     }
        // });
    }

    UpdateView(list: ProtoRecvVObj<40001>['guild_list']) {
        //let next_collect = eui. new ArrayCollection(list)
        //this._group_data.dataProvider = next_collect
        //this._group_data.itemRenderer = GuildJoinItem

        //按照评分排序
        if (list) {
            table.sort(list, (a?, b?) => {
                if (a.combat_power != b.combat_power) {
                    return a.combat_power > b.combat_power;
                } else {
                    return a.guild_lv > b.guild_lv;
                }
            });
        }
        let task = TaskModel.GetInstance().GetMainLineTaskVo();
        if (task && task.task_id == 101080) this.CreatArrow(list);
        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(this._list_items, GuildJoinItem, list, LoopScrCon.Vertical);
        } else {
            this.loop_mgr.replaceAll(list);
        }

        this._group_empty.visible = list.length < 1;
        if (!GuildModel.IsHasGuild()) {
            this.UpdateRedDot(list);
        }
    }
    CreatArrow(list) {
        if (list && Util.TableSize(list) > 0) {
            let setp_cfg = { direction: 2, text: '向所有结社发出申请吧！', effect_scaleX: 0.65, effect_scaleY: 0.9 };
            GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._btn_apply, 'UI', null, null, null, null, setp_cfg);
        } else {
            let step = { direction: 6, text: '现在没有可以申请的结社，请稍后再来～', effect_scaleX: 0.3, effect_scaleY: 1 };
            GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return, 'UI', null, null, null, null, step, true);
        }
    }

    UpdateRedDot(list?) {
        let can_join = false;
        if (list && list.length > 0) {
            for (let _tmpi in list) {
                var vo = list[_tmpi];
                if (vo.member_capacity > vo.member_num) {
                    can_join = true;
                    break;
                }
            }
        }
        this._reddot.visible = can_join;
        this.create_reddot.visible = !can_join;
    }

    _bg: Laya.Image;
    _Image111: Laya.Image;
    _btn_build: Laya.Box;
    _Image1111: Laya.Image;
    labelDisplay11: Laya.Label;
    _btn_apply: Laya.Box;
    _Image11: Laya.Image;
    labelDisplay1: Laya.Label;
    _reddot: Laya.Image;
    create_reddot: Laya.Image;
    _list_items: Laya.List;
    _group_empty: Laya.Box;
    _Image2: Laya.Image;
    _Label1: Laya.Label;
    _btn_tips: Laya.Box;
    _Image1: Laya.Image;
    labelDisplay: Laya.Label;
    public GetComponents() {
        [this._bg, this._Image111, this._btn_build, this._Image1111, this.labelDisplay11, this._btn_apply, this._Image11, this.labelDisplay1, this._reddot, this.create_reddot, this._list_items, this._group_empty, this._Image2, this._Label1, this._btn_tips, this._Image1, this.labelDisplay] = this.GetChildrenByNames(['_bg', '_Image111', '_btn_build', '_Image1111', 'labelDisplay11', '_btn_apply', '_Image11', 'labelDisplay1', '_reddot', 'create_reddot', '_list_items', '_group_empty', '_Image2', '_Label1', '_btn_tips', '_Image1', 'labelDisplay']);
    }
}
window['GuildJoinView'] = GuildJoinView;
