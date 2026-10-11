
import { BaseView1, CloseMode } from "../common/BaseView1";
import { Config } from "../common/Config";
import { EquipmentItem } from "../common/EquipmentItem";
import { EventName, SceneEventType } from "../common/EventName";
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager";
import { UI_MODEL_TYPE } from "../common/UIModelClass3D";
import { BanquetModel } from "../commonModel/BanquetModel";
import { DialogueModel, DialogueTypeConst } from "../commonModel/DialogueModel"
import { GoodsModel } from "../commonModel/GoodsModel";
import { TaskModel } from "../commonModel/TaskModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Scene } from "../scene/Scene";
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GlobalTimerQuest, SetSizeDelta, Split, Util } from "../util/Util";
import { DialogueNodeVo } from "./DialogueNodeVo";
import { BanquetAniManager } from "../marriage2/BanquetAniManager";
import { NpcVo } from "../sharedata/NpcVo";
import { NpcDialogVo } from "./NpcDialogVo";
import { JsxFlags } from "../../node_modules/typescript/lib/typescript";
import { PlatformManager } from "../PlatformManager";

export class DialogueView extends BaseView1 {
    /**
     * 界面模型大小
     */
    view_scale = 0.675 //0.75 * 0.9


    is_main_role = false

    dialog_dic = {}
    dialog_index = 1
    btn_status = -1
    task_dialog = false
    time = 0
    item_list = []
    last_show_type = 0
    down_pos_x = 0
    down_pos_y = 0

    npc_dialog_vo: NpcDialogVo
    event_id4
    event_text
    show_double_con
    delay_id
    bottom_cansGroup
    npc_vo
    timer_id
    replay_event_id
    tween_id
    idle_event_id
    tween_id2



    layer_mgr: LayerManager = LayerManager.GetInstance()
    model: DialogueModel = DialogueModel.GetInstance()

    public constructor() {
        super()
        this.base_file = "dialogue"
        this.layout_file = "DialogueView"
        this.layer_value = Enum_UILayer.Message //top
        this.close_mode = CloseMode.CloseVisible
        this.background_alpha = 0.75
        if (SceneManager.GetInstance().IsWeddingScene()) {
            this.use_background = false
        } else {
            this.use_background = true
        }

        this.load_callback = () => {
            this.LoadSuccess()
            this.InitEvent()
        }

        this.open_callback = () => {
            if (this.story_model.main_ui_finger) {
                GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.story_model.main_ui_finger, true)
            }
            this.model.dialog_is_open = true
            this.model.dialog_view = this
            this.UpdateView()
            this.ShowAnimation()
            this.SetMainUIVisible(false)
        }


        this.close_callback = () => {
            this.model.dialog_is_open = false
            this.model.dialog_view = null
            this.SetMainUIVisible(true)
            this.ClearTimer()
            if (this.npc_dialog_vo) {
                GlobalEventSystem.Fire(SceneEventType.DIALOGUE_VIEW_IS_CLOSE, this.npc_dialog_vo.npc_id)
            }
            Laya.Tween.clearAll(this._box_model)
            Laya.Tween.clearAll(this._box_bottom)

            if (this.delay_id) {
                clearTimeout(this.delay_id)
                this.delay_id = null
            }

            ResManager.GetInstance().ClearRoleMode(this.hashCode)
        }
        this.destroy_callback = () => {
            this.Remove()
        }
    }

    public LoadSuccess() {

        this.display_obj.height = this.layer_mgr.stageHeight
        this._box_model.height = this.layer_mgr.stageHeight

        SetSizeDelta(this._img_bg, this.layer_mgr.stageWidth, this.layer_mgr.stageHeight)

        this._box_dialog_con.mouseThrough = true
        this._box_get_con.mouseThrough = true
        this._box_award_con.mouseThrough = true

        // resource/game/dialogue/texture/uijq_ditu.png
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bottom_bg, "resource/game/dialogue/texture/uijq_ditu.png");
        GlobalEventSystem.Fire(EventName.SETTING_INPUT_FOCUS);
    }

    public SetMainUIVisible(value) {
        LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.Main, "DialogueView", value)
        LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.Activity, "DialogueView", value)
    }

    public Remove() {
        for (let i = 0; i < this.item_list.length; i++) {
            var v = this.item_list[i]
            v.DeleteMe()
            v = null
        }
        this.item_list = []
    }

    public Close() {
        if (this.npc_dialog_vo && this.npc_dialog_vo.task_id) {
            GlobalEventSystem.Fire(SceneEventType.AFTER_CLOSE_DIALOGUE_VIEW, this.npc_dialog_vo.task_id)
        }
        super.Close()
        GlobalEventSystem.Fire(EventName.CHECK_TO_PLAY_NEXT_DIALOGUE)
    }

    public InitEvent() {
        var onClickHandler = (e: Laya.Event) => {
            if (SceneManager.GetInstance().IsWeddingScene() && BanquetAniManager.GetInstance().bool_playing) {
                // 婚宴点击不可跳过
                return
            }
            if (
                e.target == this._img_bg
                || e.target == this._box_bottom
                || e.target == this._box_get_click
                || e.target == this._box_skip
                || e.target == this._box_go_on
            ) {
                e.stopPropagation()
                this.OnTaskSelect()
            }
        }
        Util.AddClickEvent(this._img_bg, onClickHandler, this, false)
        Util.AddClickEvent(this._box_bottom, onClickHandler, this, false)
        Util.AddClickEvent(this._box_get_click, onClickHandler, this, true)
        Util.AddClickEvent(this._box_skip, onClickHandler, this, true)
        Util.AddClickEvent(this._box_go_on, onClickHandler, this, true)


        // var touch_begin = (target, pos_x, pos_y) => {
        // 	this.down_pos_x = pos_x
        // 	this.down_pos_y = pos_y
        // }
        // var touch_end = (target, pos_x, pos_y) => {
        // 	if (this.npc_dialog_vo && this.npc_dialog_vo.task_id == 17262) { return }// 婚宴点击不可跳过
        // 	if (pos_x && pos_y) {
        // 		if (Math.abs(pos_x - this.down_pos_x) < 20) {
        // 			this.OnTaskSelect()
        // 		}
        // 	}
        // }
        // Util.AddDownEvent(this._box_model, touch_begin)
        // Util.AddUpEvent(this._box_model, touch_end)

        let hideFun = () => {
            this.Close()
        }
        this.BindEvent(GlobalEventSystem, EventName.STOP_AUTO_DO_TASK, hideFun)
    }

    public UpdateView() {

        //每次打开重置对话index
        this.dialog_index = 1

        let npc_dialog_vo = this.npc_dialog_vo

        this.npc_vo = SceneManager.Instance.GetNpcVo(npc_dialog_vo.npc_id)

        //如果只有一段内容
        if (npc_dialog_vo.GetTalkContentCount && npc_dialog_vo.GetTalkContentCount() == 1) {
            this.SetBtnState(0)
            this.task_dialog = false
        } else {
            this.task_dialog = true
        }

        if (SceneManager.GetInstance().IsWeddingScene() && BanquetAniManager.GetInstance().bool_playing) {
            //@ts-ignore
            let contentStr = npc_dialog_vo.content;
            let mainRoleVo = RoleManager.GetInstance().GetMainRoleVo();
            this._box_get.visible = false;
            //@ts-ignore
            switch (npc_dialog_vo.talker) {
                case "player":
                    // this._lb_name.text = mainRoleVo.name
                    // let head_name = "girl"
                    // if (_lb_name.career == 1) {
                    //     head_name = "boy"
                    // }
                    // resMgr.SetTexture(this, this.head_icon, `resource/game/story/texture/${head_name}.png`)
                    break
                case "sys":
                    this._lb_name.text = "系统"
                    // resMgr.SetTexture(this, this.head_icon, `resource/game/story/texture/sys.png`)
                    break
                // case "boss":
                //     let boss_vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, StoryModel.StoryBossId, false)//Config.PRELOAD_SETVER_CONFIG.config_mon[StoryModel.StoryBossId]
                //     if (boss_vo) {
                //         this._lb_name.text = boss_vo.name
                //     }
                //     // resMgr.SetTexture(this, this.head_icon, `resource/game/story/texture/boss.png`)
                //     break
                case "man":
                    let manInfo = BanquetModel.GetInstance().ManInfo(1)
                    if (manInfo) {
                        this._lb_name.text = manInfo.name
                        let manIcon = manInfo.sex == 1 ? `man` : `woman`
                        // resMgr.SetTexture(this, this.head_icon, `resource/game/marriage2/texture/${manIcon}.png`)
                    }
                    // this.next_group.visible = false
                    // iconPos_ = 0
                    break
                case "woman":
                    let womanInfo = BanquetModel.GetInstance().ManInfo(2)
                    if (womanInfo) {
                        this._lb_name.text = womanInfo.name
                        let manIcon = womanInfo.sex == 1 ? `man` : `woman`
                        // resMgr.SetTexture(this, this.head_icon, `resource/game/marriage2/texture/${manIcon}.png`)
                    }
                    // this.next_group.visible = false
                    // iconPos_ = 0
                    break
                case "sys1":
                    this._lb_name.text = "婚礼司仪"
                    // resMgr.SetTexture(this, this.head_icon, `resource/game/story/texture/girl.png`)
                    // this.next_group.visible = false
                    //@ts-ignore
                    let showInfo = BanquetModel.GetInstance().ManInfo(npc_dialog_vo.index)
                    let word12 = (showInfo && showInfo.sex == 1) ? "男人" : "女人"
                    contentStr = contentStr.replace(/@/g, word12)
                    break
                default: break
            }
            this.click_bg_toClose = false;
            this.btn_status = 5;
            this.SetDialogContent();
            this.RefreshAwardView();
            this._lb_content.text = contentStr;
            //@ts-ignore
            this._lb_go_on_desc.visible = npc_dialog_vo.hide_daoshu ? (npc_dialog_vo.hide_daoshu == 1 ? false : true) : true
        }
        else {
            this.NextDialog()
            this.AddAward()
            GlobalEventSystem.Fire(SceneEventType.DIALOGUE_VIEW_IS_OPEN, this.npc_dialog_vo.npc_id)
        }
    }

    //下一个对话
    public NextDialog() {
        let content_count = this.npc_dialog_vo.GetTalkContentCount  && this.npc_dialog_vo.GetTalkContentCount()
        if (content_count) {
            if (this.dialog_index <= content_count) {
                this.SetDialogContent(this.npc_dialog_vo.GetTalkContentByIndex(this.dialog_index))
                this.dialog_index++
            } else {
                this.Close()
            }
        } else {
            this.Close()
        }
    }

    public SetDialogContent(dialog_content?) {
        this.dialog_dic = {}
        let ask_str = ""
        let name_str = "" // 人物名称
        this.is_main_role = false

        if (dialog_content) {
            var len = dialog_content.total_list
            var list = dialog_content.list
            for (let i = 1; i <= len; i++) {
                var vo = list[i]
                var node = new DialogueNodeVo()
                node.type = vo.type
                node.text = vo.text
                node.otherInfos = Split(vo.other, "|")
                var event_text = node.type + ("|") + i
                this.dialog_dic[event_text] = node

                if (node.type == DialogueTypeConst.NPC) { //NPC对话内容
                    ask_str += node.text
                    if (this.task_dialog == true) {
                        this.SetBtnState(1)
                    }
                } else if (node.type == DialogueTypeConst.ROLE) { //角色对话内容
                    this.is_main_role = true
                    name_str = RoleManager.Instance.mainRoleInfo.name
                    ask_str += node.text
                    this.SetBtnState(1)
                } else if (
                    node.type == DialogueTypeConst.FINISH
                    || node.type == DialogueTypeConst.TALK_EVENT
                    || node.type == DialogueTypeConst.TRIGGER_AND_FINISH
                    || node.type == DialogueTypeConst.FINISH_AND_TRIGGER
                ) {
                    this.SetBtnState(2)
                    this.event_text = event_text
                } else if (node.type == DialogueTypeConst.TRIGGER) {
                    this.SetBtnState(3)
                    this.event_text = event_text
                } else if (node.type == DialogueTypeConst.BANQUET) {
                    ask_str += node.text
                    this.SetBtnState(4)
                }
            }
        }

        if (this.IsTaskFinish()) {
            this._lb_award.text = (ask_str).trim()
        } else {
            this._lb_content.text = (ask_str).trim()
        }
        this._box_model.visible = false
        this._box_name_con.visible = false
        let click_call_back = () => {
            if (this.use_delete_method) return
            this.OnTaskSelect()
        }


        let show_type = 0
        //@ts-ignore
        if (this.npc_dialog_vo && this.npc_dialog_vo.type && this.npc_dialog_vo.type == DialogueTypeConst.BANQUET) { //婚宴仪式
            let role = null
            //@ts-ignore
            if (this.npc_dialog_vo.id == BanquetModel.GetInstance().GetBrideId()) { // 女
                role = BanquetModel.GetInstance().ManInfo(2)
                name_str = role && role.name
                //@ts-ignore
            } else if (this.npc_dialog_vo.id == BanquetModel.GetInstance().GetGroomId()) { // 男
                role = BanquetModel.GetInstance().ManInfo(1)
                name_str = role && role.name
            }
            this._box_model.visible = true
            this._box_name_con.visible = true
            this._lb_name.text = name_str
            // 婚宴仪式不显示新人模型
            if (role) {
                show_type = 1
                let clothId = BanquetModel.GetInstance().GetWedidingClothId(role.sex)
                let data = {
                    career: role.career,
                    sex: role.sex,
                    clothe_res_id: clothId,
                    type: UI_MODEL_TYPE.ROLE,
                    layer_value: this.layer_value,
                    scale: this.view_scale,
                    position: { x: 0.5, y: 0.35 },
                    head_wear_id: clothId,
                    head_clothe_id: 0,
                    click_call_back: click_call_back,
                }
                ResManager.GetInstance().SetRoleModel(this, this._box_model, data)
            }
        } else if (name_str == RoleManager.Instance.mainRoleInfo.name) { //玩家自己的头像
            show_type = 2
            this._box_name_con.visible = true
            this._lb_name.text = name_str
            this._box_model.visible = true
            let main_vo = RoleManager.Instance.mainRoleInfo
            let [model_id, texture_id] = main_vo.GetRoleClotheTextureId()
            let weapon_model_id = main_vo.GetWeaponClotheId()
            let [head_model_id, head_texture_id] = main_vo.GetRoleHeadId()

            //取得当前播放的动画
            var model_load_callback = () => {
                this._box_model.visible = true
                // let uimodelclass = ResManager.GetInstance().GetPartModel(this, this._box_model)
                let uimodelclass
                if (uimodelclass) {
                    let npc = Scene.GetInstance().GetNpc(this.npc_dialog_vo.npc_id)
                    let action_list
                    if (npc) {
                        var playAnimation = () => {
                            action_list = [npc.scene_cfg_action2 || "casual"]
                            uimodelclass.PlayActions(action_list) //播放界面动画
                            npc.PlayAnimation() //重新播放场景动画
                            let last_time = npc.GetCurActionTime()
                            let to_idle = () => {
                                if (this.idle_event_id) {
                                    GlobalTimerQuest.CancelQuest(this.idle_event_id)
                                    this.idle_event_id = null
                                }
                                if (npc.state_signals["MOVE"]) {
                                    return
                                }
                                action_list = [npc.scene_cfg_action1 || "idle"]
                                uimodelclass.PlayActions(action_list)
                                let replay_fun = () => {
                                    if (this.replay_event_id) {
                                        GlobalTimerQuest.CancelQuest(this.replay_event_id)
                                        this.replay_event_id = null
                                    }
                                    if (npc.state_signals["MOVE"]) {
                                        return
                                    }
                                    playAnimation()
                                }
                                this.replay_event_id = GlobalTimerQuest.AddDelayQuest(replay_fun, 6)
                            }
                            this.idle_event_id = GlobalTimerQuest.AddDelayQuest(to_idle, last_time)
                        }
                        playAnimation()
                    }
                }
            }

            let data = {
                career: main_vo.career,
                sex: main_vo.sex,
                clothe_res_id: main_vo.GetRoleClotheId(),
                weapon_res_id: weapon_model_id,
                weapon_clothe_id: 0,
                type: UI_MODEL_TYPE.MAINROLE,
                scale: this.view_scale,
                position: { x: 0.5, y: 0 },
                fashion_model_id: model_id,
                texture_id: texture_id,
                load_call_back: model_load_callback,
                wing_id: Util.GetWingClotheId(main_vo),
                head_wear_id: head_model_id,
                head_clothe_id: head_texture_id,
                hair_id: 0,
                back_ornament_id: Util.GetBackOrnamentId(main_vo),
                click_call_back: click_call_back
            }
            ResManager.GetInstance().SetRoleModel(this, this._box_model, data)
        } else { //NPC头像
            let icon_id = 0
            let weapon_id = 0
            let texture_id = 0
            let model_scale = 1
            let type = UI_MODEL_TYPE.NPC
            if (dialog_content && dialog_content.id && dialog_content.id != 0) {
                if (dialog_content.id == 99999) { //特殊id，用作系统旁白
                    icon_id = 0
                    name_str = ""
                } else {
                    let npc_config = this.model.GetNpcCfg(dialog_content.id)
                    if (npc_config) {
                        type = NpcVo.IconType2UIType[npc_config.icon_type]
                        icon_id = npc_config.icon
                        name_str = (npc_config.name).trim()
                        weapon_id = npc_config.arm_id
                        texture_id = npc_config.texture_id
                        model_scale = Number(npc_config.talk_scale)
                    }
                }
            } else {
                let npc_config = this.model.GetNpcCfg(this.npc_dialog_vo.npc_id)
                if (npc_config) {
                    type = NpcVo.IconType2UIType[npc_config.icon_type]
                    icon_id = npc_config.icon
                    name_str = (npc_config.name).trim()
                    weapon_id = npc_config.arm_id
                    texture_id = npc_config.texture_id
                    model_scale = Number(npc_config.talk_scale)
                }
            }
            if (icon_id != 0) {
                show_type = 3
                this._box_name_con.visible = true
                this._lb_name.text = name_str
                let posy = 25
                //取得当前播放的动画
                var npc_model_load_callback = () => {
                    this._box_model.visible = true
                    let uimodelclass
                    if (uimodelclass) {
                        let npc = Scene.GetInstance().GetNpc(this.npc_dialog_vo.npc_id)
                        let action_list
                        if (npc) {
                            let playAnimation = () => {
                                let default_ac = "casual"
                                //可能用了非NPC资源，可能没休闲动作的，如果资源是减帧的，则播放速度有问题，重置待机动作
                                if (Config.PRELOAD_CLIENT_CONFIG.ConfigModelSpeed.ModelActionSpeed[Number(icon_id)]) {
                                    default_ac = "idle"
                                }
                                action_list = [npc.scene_cfg_action2 || default_ac]
                                uimodelclass.PlayActions(action_list) //播放界面动画
                                npc.PlayAnimation() //重新播放场景动画
                                let last_time = npc.GetCurActionTime()
                                let to_idle = () => {
                                    if (this.idle_event_id) {
                                        GlobalTimerQuest.CancelQuest(this.idle_event_id)
                                        this.idle_event_id = null
                                    }
                                    if (npc.state_signals["MOVE"]) {
                                        return
                                    }
                                    action_list = [npc.scene_cfg_action1 || "idle"]
                                    uimodelclass.PlayActions(action_list)
                                    let replay_fun = () => {
                                        if (this.replay_event_id) {
                                            GlobalTimerQuest.CancelQuest(this.replay_event_id)
                                            this.replay_event_id = null
                                        }
                                        if (npc.state_signals["MOVE"]) {
                                            return
                                        }
                                        playAnimation()
                                    }
                                    this.replay_event_id = GlobalTimerQuest.AddDelayQuest(replay_fun, 6)
                                }
                                this.idle_event_id = GlobalTimerQuest.AddDelayQuest(to_idle, last_time)
                                playAnimation()
                            }
                        }
                    }
                }
                //婚宴仪式不显示NPC
                let data = {
                    clothe_res_id: icon_id,
                    weapon_res_id: weapon_id,
                    type: type,
                    layer_value: this.layer_value,
                    rotate: 175,
                    scale: this.view_scale * model_scale,
                    position: { x: 0.5, y: posy / 100 },
                    texture_id: texture_id,
                    load_call_back: npc_model_load_callback,
                    click_call_back: click_call_back
                }
                ResManager.GetInstance().SetRoleModel(this, this._box_model, data)
            }
        }
        if (this.dialog_index > 1 && this.last_show_type != show_type) {
            this.ShowRoleAnimation()
        }
        this.last_show_type = show_type
        this.RefreshAwardView()
    }

    public RefreshAwardView() {
        this.show_double_con = false
        this.time = 10
        // this.time = 999
        if (this.btn_status == 3) { //任务完成
            this._box_dialog_con.visible = false
            this._box_get_con.visible = true
        } else if (this.btn_status == 5) { //婚宴
            this._box_dialog_con.visible = true
            this._box_skip.visible = false
            this.time = 5
        } else {
            this._box_dialog_con.visible = true
            this._box_get_con.visible = false
        }

        let node_vo = this.dialog_dic[this.event_text]
        if(node_vo && node_vo.type == DialogueTypeConst.TALK_EVENT){
            this._lb_get_click.text = "接取任务"
        }
        else{
            if(PlatformManager.IsEyouEnPlatform()){
                this._lb_get_click.text = "Complete"
            }else{
            this._lb_get_click.text = "完成任务"
            }
        }
        if(!TaskModel.GetInstance().GetAutoTaskSetting()&& !(SceneManager.GetInstance().IsWeddingScene() && BanquetAniManager.GetInstance().bool_playing)){
            this._lb_get_time.text = ""
            this._lb_go_on_time.text = ""
            return
        }
        this.ShouldSetAutoState(this.show_double_con)
    }

    public ShouldSetAutoState(is_show_double?) {
        this.ClearTimer()
        if (is_show_double) {
            this.time = 30
        }
        // this.time = 999
        this.CreateTimer()
    }

    public CreateTimer() {
        if (this.time > 0) {
            var onTimer = () => {
                this.time = this.time - 1
                if (this.time > 0 && !this.use_delete_method) {
                    if (this.IsTaskFinish()) {
                        this._lb_get_time.text = this.time + "秒后继续"
                    } else {
                        this._lb_go_on_time.text = String(this.time)
                    }
                } else {
                    this.ClearTimer()
                    this.OnTaskSelect()
                }
            }
            this.timer_id = GlobalTimerQuest.AddPeriodQuest(onTimer, 1, -1)
            onTimer()
        }
    }

    public ClearTimer() {
        if (this.timer_id) {
            GlobalTimerQuest.CancelQuest(this.timer_id)
            this.timer_id = null
        }
        if (this.idle_event_id) {
            GlobalTimerQuest.CancelQuest(this.idle_event_id)
            this.idle_event_id = null
        }
        if (this.replay_event_id) {
            GlobalTimerQuest.CancelQuest(this.replay_event_id)
            this.replay_event_id = null
        }
    }

    //设置物品奖励
    public AddAward() {
        for (let i = 0; i < this.item_list.length; i++) {
            var v = this.item_list[i]
            v.SetVisible(false)
        }

        let reward_list

        if (this.npc_dialog_vo.GetAwardList) {
            reward_list = this.npc_dialog_vo.GetAwardList()
        }
        if (reward_list) {
            for (let i = 0; i < reward_list.length; i++) {
                var v = reward_list[i]
                let item = this.item_list[i]
                if (item == null) {
                    item = new EquipmentItem(this._box_award_con)
                    item.SetItemSize(75, 75)
                    item.Load()
                    this.item_list[i] = item
                }
                item.SetVisible(true)
                let [goods_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(Number(v[0]), Number(v[1]))
                item.SetData(goods_id, Number(v[2]), lock)
                item.SetPosition(i * 90, 0)
            }
            if (this.btn_status == 3) { //任务完成
                this._box_dialog_con.visible = false
                this._box_get_con.visible = true
            } else {
                this._box_dialog_con.visible = true
                this._box_get_con.visible = false
            }
        } else {
            this._box_dialog_con.visible = true
            this._box_get_con.visible = false
        }
    }

    public SetBtnState(state?) {
        this.btn_status = state + 1
    }

    public IsTaskFinish() {
        return this.btn_status == 3
    }

    public SelectTask(id?, state?) {
        GlobalEventSystem.Fire(DialogueModel.SELECT_TASK, id, this.npc_dialog_vo.npc_id, state)
    }

    public OnTaskSelect() {
        this.ClearTimer()
        if (this.npc_dialog_vo == null) {
            this.Close()
            return
        }
        // console.log("clickDialog:" + this.btn_status + ",task_id:" + this.npc_dialog_vo.task_id)
        if (this.btn_status == 1) {//离开
            this.Close()
        } else if (this.btn_status == 2) {//继续对话
            if (this.npc_dialog_vo.task_list && this.npc_dialog_vo.task_list.length > 0 && TaskModel.GetInstance().now_select_task_id && TaskModel.GetInstance().now_select_task_id != 0) {
                this.SelectTask(this.npc_dialog_vo.task_list[0].task_id, this.npc_dialog_vo.task_list[0].task_state);
                return
            }
            this.NextDialog()
        } else if (this.btn_status == 3 || this.btn_status == 4) {
            //完成任务
            if (this.npc_dialog_vo.task_list.length > 0) {
                this.SelectTask(this.npc_dialog_vo.task_list[0].task_id, this.npc_dialog_vo.task_list[0].taskState);
                return
            }
            let event_text = this.event_text;
            if (!this.dialog_dic[event_text]) {
                return
            }
            GlobalEventSystem.Fire(DialogueModel.CLICK_ANSWER, this.npc_dialog_vo, this.dialog_dic[event_text])
            this.Close()
        } else if (this.btn_status == 5) { // 婚宴仪式
            this._box_dialog_con.visible = true
            this._box_skip.visible = false
            this.NextDialog()
        } else {
            this.Close()
        }
    }


    //动画
    public ShowAnimation() {
        if (this.use_delete_method) {
            return
        }
        Laya.Tween.clearAll(this._box_model)
        Laya.Tween.clearAll(this._box_bottom)

        this._box_bottom.centerY = 570
        Laya.Tween.to(this._box_bottom, { centerY: 472 }, 80, Laya.Ease.circIn, Laya.Handler.create(this, () => {

        }));
        this.ShowRoleAnimation()
    }

    public ShowRoleAnimation() {
        this._box_model.centerX = -80
        Laya.Tween.to(this._box_model, { centerX: 0 }, 120, Laya.Ease.circIn);
    }

    public Open(npc_dialog_vo?) {
        if (!npc_dialog_vo) {
            return
        }
        this.npc_dialog_vo = npc_dialog_vo
        super.Open()
    }

    _img_bg: Laya.Image
    _box_model: Laya.Box
    _box_skip: Laya.Box
    _img_skip: Laya.Image
    _box_bottom: Laya.Box
    _img_bottom_bg: Laya.Image
    _box_name_con: Laya.Box
    _img_name_bg: Laya.Image
    _lb_name: Laya.Label
    _box_dialog_con: Laya.Box
    _lb_content: Laya.Label
    _box_go_on: Laya.Box
    _lb_go_on_time: Laya.Label
    _lb_go_on_desc: Laya.Label
    _box_get_con: Laya.Box
    _lb_award: Laya.Label
    _box_award_con: Laya.Box
    _box_get: Laya.Box
    _lb_get_time: Laya.Label
    _box_get_click: Laya.Box
    _img_get_click_bg: Laya.Image
    _lb_get_click: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._box_model,
            this._box_skip,
            this._img_skip,
            this._box_bottom,
            this._img_bottom_bg,
            this._box_name_con,
            this._img_name_bg,
            this._lb_name,
            this._box_dialog_con,
            this._lb_content,
            this._box_go_on,
            this._lb_go_on_time,
            this._lb_go_on_desc,
            this._box_get_con,
            this._lb_award,
            this._box_award_con,
            this._box_get,
            this._lb_get_time,
            this._box_get_click,
            this._img_get_click_bg,
            this._lb_get_click,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_box_model",
                "_box_skip",
                "_img_skip",
                "_box_bottom",
                "_img_bottom_bg",
                "_box_name_con",
                "_img_name_bg",
                "_lb_name",
                "_box_dialog_con",
                "_lb_content",
                "_box_go_on",
                "_lb_go_on_time",
                "_lb_go_on_desc",
                "_box_get_con",
                "_lb_award",
                "_box_award_con",
                "_box_get",
                "_lb_get_time",
                "_box_get_click",
                "_img_get_click_bg",
                "_lb_get_click",
            ])
    }
}
window["DialogueView"] = DialogueView