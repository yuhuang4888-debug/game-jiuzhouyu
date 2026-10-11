
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { ResManager } from '../common/ResManager';
import { ChatModel, ChatModelEvent } from '../commonModel/ChatModel';
import { GhostWalkEvent, GhostWalkModel, IGhostWalkBossTeamHurtInfo } from '../commonModel/GhostWalkModel';
import { RoleManager } from '../commonModel/RoleManager';
import { TeamEvent, TeamModel } from '../commonModel/TeamModel';
import { SceneManager } from '../scene/SceneManager';
import { Message } from '../sysInfo/SysInfoController';
import { Util } from '../util/Util';
import { Config } from '../common/Config';
import { EventName } from '../common/EventName';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';

export class GhostWalkSceneDamageItem extends BaseItemRenderer {
    WIDTH = 240;
    HEIGT = 36
    is_need_fresh;
    data: IGhostWalkBossTeamHurtInfo;
    str_list = ['ui_phb_11', 'ui_phb_12', 'ui_phb_13'];
    _chat_model
    g_model

    teamActivityType = 10
    teamSubType = 1

    team_model

    public constructor() {
        super();
        this.is_need_fresh = false;
        this.base_file = 'ghostWalk';
        this.layout_file = 'GhostWalkSceneDamageItem';
        this._chat_model = ChatModel.GetInstance()
        this.team_model = TeamModel.GetInstance()
        this.g_model = GhostWalkModel.ins;

        this.load_callback = () => {
            Util.AddClickEvent(this._click_box, () => {
                if (!this.data) return
                if (!this.IsCanIniv(true)) return
                this.g_model.select_index = this.data.teamId
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GhostWalkChatMenuView", this._click_box, this.GetBtnText())
            }, this, true)


            //更改队伍目标成功
            this.BindEvent(this.team_model, TeamEvent.TEAM_CHANGE_TARGET_SUCCESS, () => {
                if (this.data && this.g_model.select_index == this.data.teamId) {
                    this.InviTeam()
                }
            }
            )


            //创建队伍成功
            this.BindEvent(this.team_model, TeamEvent.TEAM_BUILD_SUCCESS, () => {
                if (this.data && this.g_model.select_index == this.data.teamId) {
                    this.InviTeam()
                }
            }
            )


            this.BindEvent(this.g_model, GhostWalkEvent.CLICK_GROUP_BTN, () => {
                if (this.data&&this.data.teamId == this.g_model.select_index) {
                    this.ClickEvent()
                }
            });


        }
        this.Load();
    }

    /**获取显示的按钮文字 */
    public GetBtnText() {
        if (!this.data.isTeam) return "邀请组队"
        return "申请入队"
    }

    /**是否可以邀请
     */
    public IsCanIniv(is_tip) {
        if (!this.data) return false
        //判断是否是自己的队伍
        let playerInfos = this.data.playerInfo || []
        let my_role_id = RoleManager.GetInstance().GetMainRoleId()
        for (let i = 0; i < playerInfos.length; i++) {
            if (playerInfos[i].player_id == my_role_id) {
                if (is_tip) Message.show("已方~")
                return false
            }
        }


        let team_info = this.team_model.team_info

        //已有队伍
        if (team_info && team_info.activity_id > 0) {
            if (!TeamModel.GetInstance().IsLeaderInTeam(my_role_id)) {
                if (is_tip) Message.show("队长才可以操作")
                return false
            }

            //队伍对队伍
            if (this.data.isTeam && team_info.activity_id == this.teamActivityType) {
                if (is_tip) Message.show("队伍间不能互相邀请")
                return false
            }


        }
        return true

    }



    /**点击事件*/
    public ClickEvent() {
        if (!this.data) return

        if (!this.IsCanIniv(false)) return

        //队伍配置
        let team_cfg = Config.PRELOAD_SERVER_CONFIG.config_team_ui["10@1"]
        if (!team_cfg) {
            return
        }


        //需要修改队伍目标
        let team_info = this.team_model.team_info
        if (team_info && team_info.activity_id > 0 && team_info.activity_id != this.teamActivityType) {

            let scene_id = SceneManager.GetInstance().GetSceneId()
            this.team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24017, "ccihhi",
                team_cfg.activity_id, team_cfg.subtype_id, scene_id, team_cfg.default_lv_min, team_cfg.default_lv_max, 0)
            return
        }


        //个人对个人  邀请方先创建队伍
        if ((!team_info || team_info.activity_id == 0) && !this.data.isTeam) {
            let scene_id = SceneManager.GetInstance().GetSceneId()
            this.team_model.single_match_state = team_cfg.activity_id
            this.team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24000, "ccihhi",
                team_cfg.activity_id, team_cfg.subtype_id, scene_id, team_cfg.default_lv_min, team_cfg.default_lv_max, 0)
            return
        }


        //开始邀请组队
        this.InviTeam()

    }


    /**邀请组队 */
    public InviTeam() {
        //当前组队类型
        let playerInfos = this.data.playerInfo || []
        if (playerInfos && playerInfos.length < 0) return

        //当前自己的组队信息
        let team_info = this.team_model.team_info

        if (team_info) {
            //队伍对个人
            let sing_info = playerInfos[0]
            this.team_model.Fire(TeamEvent.TEAM_REQUEST_OTHER_PROTO, 24057, [[sing_info.server_id, sing_info.player_id]])
            Message.show("已发出组队邀请")
            this.g_model.select_index = -1
        } else {

            if (this.data.isTeam) {
                //个人对队伍  申请加队
                this.team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24002, "lcc", this.data.teamId, this.teamActivityType, this.teamSubType)
                Message.show("已发送加队申请")
                this.g_model.select_index = -1
            }
        }


    }

    public dataChanged() {
        if (!super.dataChanged()) return;
        let data = this.data;
        if (data.isTeam) {
            this._lb_name.text = `${data.teamName.slice(0, 3)}${data.teamName.length > 3 ? '...' : ''}队伍`;
        } else {
            this._lb_name.text = data.teamName;
        }
        this._lb_hurt.text = `${data.teamHurtPercent}%`;
        // this._lb_hurt.text = `${data.teamHurt}`;
        let is_three = this.index < 3;
        this._img_rank.visible = is_three;
        this._lb_rank.visible = !is_three;
        if (is_three) {
            let str = this.str_list[this.index];
            ResManager.GetInstance().SetImageSprite(this, this._img_rank, 'ghostWalk', str, true);
        } else {
            this._lb_rank.text = `${this.index + 1}`;
        }
    }

    _img_line: Laya.Image
    _img_rank: Laya.Image
    _lb_name: Laya.Label
    _lb_hurt: Laya.Label
    _lb_rank: Laya.Label
    _click_box: Laya.Box
    public GetComponents() {
        [
            this._img_line,
            this._img_rank,
            this._lb_name,
            this._lb_hurt,
            this._lb_rank,
            this._click_box,
        ]
            = this.GetChildrenByNames([

                "_img_line",
                "_img_rank",
                "_lb_name",
                "_lb_hurt",
                "_lb_rank",
                "_click_box",
            ])
    }
}
window["GhostWalkSceneDamageItem"] = GhostWalkSceneDamageItem