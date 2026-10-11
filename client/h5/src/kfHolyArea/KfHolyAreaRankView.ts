import { BaseView1 } from "../common/BaseView1"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { KfHolyAreaAuctionRankItem } from "./KfHolyAreaAuctionRankItem"
import { table } from "../common/table"
import { SYTweenLite } from "../util/SYTweenLite"
import { GuildFightModel, GuildFightEvent } from "../commonModel/GuildFightModel"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { KfHolyAreaRankItem } from "./KfHolyAreaRankItem"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SceneManager } from "../scene/SceneManager"

export class KfHolyAreaRankView extends BaseView1 {
    scene_id
    loop_mgr
    kfModel
    now_index
    rank_list
    cur_model

    public constructor() {
        super()
        this.base_file = "kfHolyArea"
        this.layout_file = "KfHolyAreaRankView"
        this.dependent_res = ["kfHolyArea", "rank"]
        this.kfModel = KfHolyAreaModel.GetInstance()
        this.layer_value = Enum_UILayer.Activity
        this.show_open_movie = true
        this.is_center = true
        this.destroy_imm = true
        this.change_scene_close = true
        this.use_background = true
        this.click_bg_toClose = true
        this.cur_model = ""
        this.load_callback = () => {
            this.LoadSuccess()
        }

        this.destroy_callback = () => {
            this.Remove()
        }
    }

    public Open(...new_args) {
        if (new_args) {
            this.scene_id = new_args[0]
        }
        super.Open()
    }

    public LoadSuccess() {
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_img, GameResPath.GetIcon("kfHolyArea", "ui_holyland_70"));
        ResManager.GetInstance().SetImageSprite(this, this.img_rank, "rank_asset", "rank_icon_" + 1 + "", true)
        if (this.scene_id) {
            this.kfModel.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28422, this.scene_id)
        }
        this.InitEvent()
        this.UpdateView()
    }

    public InitEvent() {
        Util.AddClickEvent(this._gp_close, () => {
            this.Close()
        }, this, true)

        Util.AddClickEvent(this._img_tips, () => {
            GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.KfHolyArea4)
        }, this, true)

        this.BindEvent(this.kfModel, KfHolyAreaModel.UPDATE_REFRESH_INDIVIDUAL_SCORE, (scmd?) => {
            console.log("个人积分数据", scmd);

            if (scmd.scene_id == this.scene_id) {
                this.updateMyRank(scmd)
            }
        })

        this.BindEvent(this.kfModel, KfHolyAreaModel.UPDATE_SCENE_DATA, (scene_id?) => {
            if (scene_id == this.scene_id) {
                this.UpdateView()
                // if (this.scene_id) {
                //     this.kfModel.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28422, this.scene_id)
                // }
            }
        })

        Util.AddClickEvent(this._img_box, () => {
            this.kfModel.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28408, this.scene_id)
            this._gp_box.visible = false
        }, this, true)

        this.BindEvent(GuildFightModel.GetInstance(), GuildFightEvent.UPDATE_REQUEST_FIGURE_2, (scmd?) => {
            let _date = this.rank_list[0];
            if (scmd.model_id != 284 || !_date || _date.player_id != scmd.role_id) {
                return
            }
            this.UpdateModel(scmd.figure)
        })
    }

    public UpdateView() {
        let _scenData = this.kfModel.GetSceneData(this.scene_id);
        if (_scenData && _scenData.rank_list) {
            let _list = _scenData.rank_list;
            if (_list.length > 1) {
                table.sort(_list, (a, b) => {
                    return b.rank > a.rank
                })
            }
            this.rank_list = _list;
            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this.Content, KfHolyAreaRankItem, _list, LoopScrCon.Vertical, 1)
            } else {
                this.loop_mgr.replaceAll(_list)
            }
            if (_list.length == 0) {
                this.img_rank.visible = false;
                this.name_lb.text = "未上榜"
            } else {
                this.img_rank.visible = true;
                this.name_lb.text = _list[0].role_name;
            }
            let server_list = this.kfModel.GetCampServerList(_scenData.bl_server)

            if (server_list && server_list[0]) {
                let server_data = server_list[0]
                this.server_name.text = `占领服务器：S${server_data.server_num}.${server_data.server_name}`
            }
            this._gp_box.visible = _scenData.bl_reward_recieve == 1
            ResManager.GetInstance().SetImageSprite(this, this._img_box, "kfHolyArea_asset", "box_" + _scenData.con_type + "_0", true)
            let sceneInfo = SceneManager.GetInstance().GetSceneInfo(this.scene_id)
            this.title_lb.text = `${sceneInfo.name}占领贡献榜`
            if (this._gp_box.visible) {
                this.StartAction()
            } else {
                this.StopAction()
            }
            let _player_data = this.rank_list[0]
            if (_player_data) {
                GuildFightModel.GetInstance().Fire(GuildFightEvent.GUILDFIGHT_REQUEST_PROTO, 13015, "hlh", _player_data.server_id, _player_data.player_id, 284)
            }
        }
    }

    public SwitchView(index?) {

        // if (this.now_index == index) {
        // 	return
        // }
        // this.now_index = index;
        // let _data = this.rank_list[index];
        // if(_data){
        //     GuildFightModel.GetInstance().Fire(GuildFightEvent.GUILDFIGHT_REQUEST_PROTO, 13015, "hlh", _data.server_id, _data.player_id, 284)
        // }
    }

    private updateMyRank(scmd?) {
        let rank: number = 0
        let score: number = 0
        let kill_score: number = 0
        if (scmd) {
            rank = scmd.rank
            score = scmd.score
            kill_score = scmd.kill_score
        }
        this.rank_lb.text = (rank > 0 ? (String(scmd.rank)) : ("未上榜"))
        this.score_lb.width = 450
        this.score_lb.style.fontSize = 18
        this.score_lb.style.color = "#663915"
        this.score_lb.innerHTML = Util.StrToHTML(score + kill_score + "（击杀积分：<font color='#4a3a32'>" + kill_score + "；个人积分："
            + score + "）</font>")
    }

    private UpdateModel(role_vo?) {
        if (!role_vo) {
            return
        }

        if (this.cur_model == role_vo.name) {
            return
        }
        this.cur_model = role_vo.name
        let [model_id, texture_id] = Util.GetRoleClotheId(role_vo)
        let weapon_model_id, weapon_texture_id = Util.GetWeaponClotheId(role_vo)
        let [head_id, head_texture_id] = Util.GetRoleHeadId(role_vo)
        let hair_id = 0
        let data = {
            career: role_vo.career,
            sex: role_vo.sex,
            clothe_res_id: model_id,
            fashion_model_id: model_id, //暂时屏蔽一下时装
            texture_id: texture_id,
            weapon_res_id: weapon_model_id,
            weapon_clothe_id: weapon_texture_id,
            type: UI_MODEL_TYPE.MAINROLE,
            layer_value: this.layer_value,
            scale: 1,
            wing_id: Util.GetWingClotheId(role_vo),
            // liveness_id: role_vo.liveness_id,
            head_wear_id: head_id,
            head_clothe_id: head_texture_id,
            hair_id: hair_id,
            back_ornament_id: Util.GetBackOrnamentId(role_vo),
            layout_file: this.layout_file
        }
        ResManager.GetInstance().SetRoleModel(this, this._gp_model, data)
    }

    tween_list
    wait_time_id
    public StartAction() {
        this.StopAction()
        this.PlayTween()
    }

    public ClearTween() {
        if (this.tween_list) {
            for (let i = 0; i < this.tween_list.length; i++) {
                var v = this.tween_list[i]
                SYTweenLite.Stop(v)
            }
            this.tween_list = false
        }
    }

    public ClearTimer() {
        if (this.wait_time_id) {
            clearTimeout(this.wait_time_id)
            this.wait_time_id = false
        }
    }

    public StopAction() {
        this.ClearTween()
        this.ClearTimer()
    }

    public PlayTween() {
        if (!this.tween_list) {
            this.tween_list = []
        }
        table.insert(this.tween_list, SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, -30, 0.15, () => {
            table.insert(this.tween_list, SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, 30, 0.3, () => {
                table.insert(this.tween_list, SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, 0, 0.15, () => {
                    this.WaitTime()
                }))
            }))
        }))
    }

    public WaitTime() {
        this.ClearTween()
        this.wait_time_id = setTimeout(() => {
            this.PlayTween()
        }, 0.15)
    }

    public Remove() {
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
        this.now_index = -1;
        this.cur_model = "";
        this.StopAction();
        if (this.kfModel.is_jump_tips) {
            this.kfModel.jumpSceneId(this.scene_id)
        }
    }

    bg_img: Laya.Image
    title_lb: Laya.Label
    server_name: Laya.Label
    _gp_box: Laya.Box
    _gp_behind: Laya.Box
    _img_box: Laya.Image
    _gp_front: Laya.Box
    _Group2: Laya.Box
    _gp_model: Laya.Box
    img_rank: Laya.Image
    name_lb: Laya.Label
    Content: Laya.List
    rank_lb: Laya.Label
    score_lb: Laya.HTMLDivElement
    _gp_close: Laya.Box
    _img_tips: Laya.Image
    public GetComponents() {
        [
            this.bg_img,
            this.title_lb,
            this.server_name,
            this._gp_box,
            this._gp_behind,
            this._img_box,
            this._gp_front,
            this._Group2,
            this._gp_model,
            this.img_rank,
            this.name_lb,
            this.Content,
            this.rank_lb,
            this.score_lb,
            this._gp_close,
            this._img_tips,
        ]
            = this.GetChildrenByNames([

                "bg_img",
                "title_lb",
                "server_name",
                "_gp_box",
                "_gp_behind",
                "_img_box",
                "_gp_front",
                "_Group2",
                "_gp_model",
                "img_rank",
                "name_lb",
                "Content",
                "rank_lb",
                "score_lb",
                "_gp_close",
                "_img_tips",
            ])
    }
}
window["KfHolyAreaRankView"] = KfHolyAreaRankView