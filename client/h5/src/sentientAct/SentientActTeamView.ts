import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { RoleManager } from '../commonModel/RoleManager';
import { SentientActEvent, SentientActModel } from '../commonModel/SentientActModel';
import { TeamEvent, TeamModel } from '../commonModel/TeamModel';
import { Util } from '../util/Util';
import { SentientActTeamApplyView } from './SentientActTeamApplyView';
import { SentientActTeamListView } from './SentientActTeamListView';
import { SentientActTeamRoleView } from './SentientActTeamRoleView';
import { SentientActTeamTabItem } from './SentientActTeamTabItem';

export class SentientActTeamView extends BaseView1 {
    LoadSuccess;
    InitEvent;
    loop_mgr: LoopScrowViewMgr;
    click_fun;
    SwitchView;
    UpdateSubView;
    InitTab;
    SelectView;
    viewclass_list;
    titleText;
    teamActivityType: number;
    teamSubType: number;
    cur_index_: number;
    param_
    public constructor() {
        super();

        this.base_file = 'sentientAct';
        this.layout_file = 'SentientActTeamView';
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.show_open_movie = true;
        this.is_delay_callback = false;
        this.change_scene_close = true;
        this.viewclass_list = [
            SentientActTeamListView,
            SentientActTeamRoleView,
            SentientActTeamApplyView
        ];
        this.teamActivityType = 9;
        this.teamSubType = 1;
        this.cur_index_ = 0;
        this.titleText = '众生之门';
        let view_list_ = [];
        let tab_data = [];
        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        };

        this.open_callback = () => { };

        this.close_callback = () => {
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe();
                this.loop_mgr = null;
            }
            for (let key in view_list_) {
                // [ts2lua]view_list_下标访问可能不正确
                view_list_[key].DeleteMe();
            }
            view_list_ = [];
        };

        this.destroy_callback = () => { };
        this.click_fun = (e?) => {
            let data = this.tab_list.array;
            if (data) {
                let index = data[this.tab_list.selectedIndex].id;
                this.SwitchView(index);
            }
        };

        this.LoadSuccess = () => {
            let red = false;
            this.lblTitle.text = this.titleText;
            if (TeamModel.GetInstance().apply_list) {
                let list = TeamModel.GetInstance().apply_list;
                red = list.length > 0;
            }

            this.InitTab(red);
        };
        this.SelectView = (index1, red?) => {
            this.InitTab(red);
            let have_team =
                (TeamModel.GetInstance().team_info &&
                    TeamModel.GetInstance().team_info.team_id &&
                    true) ||
                false;
            let index = have_team ? 1 : 0;
            this.loop_mgr.SetSelectIndex(index);
            this.SwitchView(index);
        };

        this.InitEvent = () => {
            Util.AddClickEvent(
                this.close,
                () => {
                    this.Close();
                },
                true
            );
            this.BindEvent(TeamModel.GetInstance(), TeamEvent.TEAM_BUILD_SUCCESS, () => {
                this.SelectView(1);
            });
            this.BindEvent(TeamModel.GetInstance(), TeamEvent.QUIT_TEAM_SUCCESS, () => {
                this.SelectView(0);
            });
            this.BindEvent(
                TeamModel.GetInstance(),
                TeamEvent.TEAM_UPDATE_TERAM_HALL,
                (activity_id?, subtype?) => {
                    if (activity_id == this.teamActivityType && subtype == this.teamSubType) {
                        this.SelectView(1);
                    }
                }
            );
            this.BindEvent(TeamModel.GetInstance(), TeamEvent.TEAM_UPDATE_TERAM_INFO, () => {
                let have_team =
                    (TeamModel.GetInstance().team_info &&
                        TeamModel.GetInstance().team_info.team_id &&
                        true) ||
                    false;
                if (!have_team) {
                    this.SelectView(0);
                }
            });

            SentientActModel.GetInstance().Fire(SentientActEvent.REQUEST_PROTO, 24109);
        };
        this.InitTab = (red?) => {
            let team_info = TeamModel.GetInstance().team_info;

            tab_data = [{ name: '队伍列表' }];
            if (team_info && team_info.activity_id == this.teamActivityType) {
                tab_data = [{ name: '队伍列表' }, { name: '我的队伍' }];
                for (let key in team_info.team_member_list) {
                    let vo = team_info.team_member_list[key];
                    if (
                        vo.id == RoleManager.GetInstance().GetMainRoleId() &&
                        vo.team_position == 1
                    ) {
                        tab_data = [
                            { name: '队伍列表' },
                            { name: '我的队伍' },
                            { name: '申请列表', red: red }
                        ];
                        break;
                    }
                }
            }
            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr();
                this.loop_mgr.SetData(
                    this.tab_list,
                    SentientActTeamTabItem,
                    tab_data,
                    LoopScrCon.Horizontal,
                    1,
                    () => {
                        this.SwitchView();
                    }
                );
            } else {
                this.loop_mgr.replaceAll(tab_data);
            }
            if (team_info && team_info.activity_id == 9) {
                this.loop_mgr.SetSelectIndex(1);
                this.SwitchView(1);
            }
        };
        this.SwitchView = (index?) => {
            if (index == null) {
                index = false;
            }
            // [ts2lua]lua中0和空字符串也是true，此处is_index需要确认
            let select_index = index || this.tab_list.selectedIndex;
            if (select_index == 2)
                SentientActModel.GetInstance().Fire(SentientActEvent.UPDATE_APPLY_RED, false);
            this.cur_index_ = select_index;

            this.UpdateSubView(this.param_);
            this.param_ = null //用完一次就干掉
        };

        this.UpdateSubView = (...new_args) => {
            // [ts2lua]view_list_下标访问可能不正确
            let view = view_list_[this.cur_index_];
            if (!view) {
                // [ts2lua]viewclass_list_下标访问可能不正确
                let viewclass = this.viewclass_list[this.cur_index_];
                view = new viewclass(this.view_gp);
                view.Load();
                // [ts2lua]view_list_下标访问可能不正确
                view_list_[this.cur_index_] = view;
            }
            view.SetData(...new_args);
            this.PopUpChild(view);
        };
    }


    public Open(...new_args) {
        this.param_ = new_args
        super.Open()
    }

    lblTitle: Laya.Label;
    tab_list: Laya.List;
    view_gp: Laya.Box;
    close: Laya.Image;
    public GetComponents() {
        [this.lblTitle, this.tab_list, this.view_gp, this.close] = this.GetChildrenByNames([
            'lblTitle',
            'tab_list',
            'view_gp',
            'close'
        ]);
    }
}
window['SentientActTeamView'] = SentientActTeamView;
