import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { CookieWrapper } from "../common/CookieWrapper"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { QuestionNaireModel } from "../commonModel/QuestionNaireModel"
import { RoleManager } from "../commonModel/RoleManager"
import { LoginModel } from "../login/LoginModel"
import { PlatformManager } from "../PlatformManager"
import { MainRoleVo } from "../sharedata/MainRoleVo"
import { Message } from "../sysInfo/SysInfoController"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { HttpUtil } from "../util/HttpUtil"
import { md5 } from "../util/md5"
import { Util } from "../util/Util"
import { QuestionNaireDescribeItem } from "./QuestionNaireDescribeItem"
import { QuestionNaireImageItem } from "./QuestionNaireImageItem"

class QuestionNaireMainView extends BaseItem1 {
    _img_bg: Laya.Image
    _gp_item: Laya.Box
    _gp_effect: Laya.Box
    _img_red: Laya.Image
    _gp_bottom: Laya.Box
    _gp_last: Laya.Box
    _lab_num: Laya.Label
    _gp_next: Laya.Box
    _gp_hand: Laya.Box
    _gp_question: Laya.Box
    _lab_subject: Laya.Label
    select_scroller: Laya.Box
    _gp_describe: Laya.Box
    _gp_image: Laya.Panel
    _gp_text_input: Laya.Box
    _lab_input: Laya.TextInput
    _lab_font_num: Laya.Label
    _lab_prompt: Laya.Label
    _gp_receive: Laya.Box
    _lab_tip: Laya.HTMLDivElement
    _gp_go: Laya.Box


    LoadSuccess
    UpdateView
    AddEffect
    InitEvent
    CreateSubject
    ClearItemList
    AutoNextSubject
    SetButton
    IsSelect
    InitInputEvent
    public constructor(parent) {
        super(parent)
        this.base_file = "questionNaire"
        this.layout_file = "QuestionNaireMainView"
        let model = QuestionNaireModel.GetInstance()
        let res_mgr = ResManager.GetInstance(),
            local_QuestionNaireModel = QuestionNaireModel,
            custom_model = CustomActivityModel.GetInstance(),
            local_Number = Number,
            local_Util = Util,
            local_CustomActivityDefine = CustomActivityDefine,
            local_Message = Message,
            cookie_wrapper = CookieWrapper.GetInstance(),
            GAME_MAIN_VERSION = CookieWrapper.GAME_MAIN_VERSION,
            local_HttpUtil = HttpUtil,
            now_id_ = 0,
            item_list_,
            subject_num_,
            item_: BaseAwardItem,
            
            reward_type_,
            reward_id_,
            reward_num_,
            questionnaire_type_,
            receive_stage_,
            min_select_num_


        this.load_callback = ()=> {
            this.LoadSuccess()
            this.InitEvent()
        }

        this.LoadSuccess = () => {
            this._gp_image.vScrollBar.visible = false
            this._lab_tip.style.fontSize = 22
            this._lab_tip.style.color = "#4A3A32"
            this._lab_tip.style.wordWrap = true
            res_mgr.SetTexture(this, this._img_bg, GameResPath.GetIconJpgOtherPath("questionNaire", "uiwjdc_004"))
            questionnaire_type_ = model.questionnaire_type ? model.questionnaire_type : 1
            let info = custom_model.GetActData(local_QuestionNaireModel.QUESTIONNAIRE_ACT_BASE_TYPE, questionnaire_type_)
            let reward = ErlangParser.GetInstance().Parse(info.reward_list[0].reward)
            let id = reward_id_ = local_Number(reward[0][1])
            reward_num_ = local_Number(reward[0][2])
            reward_type_ = local_Number(reward[0][0])
            if (!item_) {
                item_ = new BaseAwardItem(this._gp_item);
                item_.Load()
                item_.SetItemSize(90, 90)
            }
            item_.SetData(id)
            item_.SetClickCallBack(() => {
                return
            })
            let data = custom_model.GetActData(90, questionnaire_type_)
            let stage = data.reward_list[0].status
            model.red_status = stage == 1 ? true : false
            GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "90@331", model.red_status)
            this.UpdateView()
        }
        this.UpdateView = () => {
            let info = custom_model.GetActData(local_QuestionNaireModel.QUESTIONNAIRE_ACT_BASE_TYPE, questionnaire_type_)
            let stage = receive_stage_ = info.reward_list[0].status
            if (stage == 2) {
                model.Fire(local_QuestionNaireModel.CLOSE_QUESTIONNAIRE_VIEW, "QuestionNaireBaseView")
                return
            }
            this._img_red.visible = stage == 1 ? true : false
            this._gp_bottom.visible = this._gp_question.visible = (stage == 1 || now_id_ == 0) ? false : true
            this._gp_receive.visible = (stage == 1 || now_id_ == 0) ? true : false
            this._gp_go.visible = false
            let str = `谢谢您的参与，我们会认真对待您的意见~<font color='#639c12'>请领取右上角的礼包奖励</font>吧`
            if (stage != 1 && now_id_ == 0) {
                str = `能否耽误您几分钟的历练时间，为我们回答一份调查问卷呢？完成后可<font color='#639c12'>领取右上角的小礼包</font>哦`
                this._lab_tip.innerHTML = local_Util.StrToHTML(str)
                this._gp_go.visible = true
            }
            if (stage == 1) {
                this.AddEffect()
                this._lab_tip.innerHTML = local_Util.StrToHTML(str)
            }
            else
                this.ClearUIEffect(this._gp_effect)
            this._lab_tip.style.width = 330
        }

        this.AddEffect = () => {
            this.ClearUIEffect(this._gp_effect)
            this.AddUIEffect("ui_goods_orange_plus", this._gp_effect, { x: 0, y: 1.3 }, 4, true)
        }

        this.InitEvent = () => {
            this.BindEvent(model, local_QuestionNaireModel.AUTO_NEXT_SUBJECT, (id) => {
                if (now_id_ == subject_num_ || id != now_id_) return
                this.AutoNextSubject()
            })
            this.BindEvent(model, local_QuestionNaireModel.UPDATE_VIEW, () => {
                this.UpdateView()
            })
            this.BindEvent(custom_model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, (b, s, reward) => {
                if (b == local_QuestionNaireModel.QUESTIONNAIRE_ACT_BASE_TYPE && s == questionnaire_type_)
                    custom_model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 33101)
            })
            let hand_ind_call_back = (vo) => {
                let v = JSON.parse(vo)
                if (v.error == 0) {
                    custom_model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 33236, questionnaire_type_)
                }
                else {
                    local_Message.show("提交问卷失败，请阴阳师重新提交试试吧")
                }
            }
            local_Util.AddClickEvent(this._gp_next, () => {
                if (!this.IsSelect()) {
                    local_Message.show("当前题目未作答哦，请选择答案吧")
                    return
                }
                this.AutoNextSubject()
            }, this, true)
            local_Util.AddClickEvent(this._gp_go, () => {
                now_id_ = 1
                this.CreateSubject(now_id_)
                this._gp_receive.visible = this._gp_go.visible = false
                this._gp_bottom.visible = this._gp_question.visible = true
            }, this, true)
            local_Util.AddClickEvent(this._gp_last, () => {
                this.ClearItemList()
                now_id_ -= 1
                this.CreateSubject(now_id_)
            }, this, true)
            local_Util.AddClickEvent(this._gp_item, () => {
                if (receive_stage_ == 1) {
                    custom_model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, local_QuestionNaireModel.QUESTIONNAIRE_ACT_BASE_TYPE, questionnaire_type_, 1)
                } else {
                    let info = custom_model.GetActData(local_QuestionNaireModel.QUESTIONNAIRE_ACT_BASE_TYPE, questionnaire_type_)
                    let reward = ErlangParser.GetInstance().Parse(info.reward_list[0].reward)
                    let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0][0], reward[0][1])
                    UIToolTipMgr.GetInstance().AppendGoodsTips(type, null, null, null, reward[0][2], null, this)
                }
            }, this, true)
            local_Util.AddClickEvent(this._gp_hand, () => {
                if (this._lab_input.text.length <= 0) {
                    local_Message.show("当前还有未完成的题目，不要心急哦")
                    return
                }
                let role_vo: MainRoleVo = RoleManager.GetInstance().GetMainRoleVo(),
                    role_id = role_vo.role_id,
                    name = role_vo.name,
                    source = PlatformManager.GetPlatformName()
                let dir = model.GetSelectDir()
                let answard_vo = ``
                let list = model.type_id_dir
                if (dir && local_Util.TableSize(dir) > 0) {
                    for (let id in dir) {
                        let vo = dir[id]
                        let str = ``
                        if (vo && local_Util.TableSize(vo)) {
                            let a = 1, length = 0
                            for (let i in vo) {
                                if (vo[i])
                                    length++
                            }
                            for (let index in vo) {
                                let answard = vo[index]
                                if (answard) {
                                    str += a == length ? String(index) : String(index) + ","
                                    a++
                                }
                            }
                        }
                        answard_vo += `"${id}":"${str}",`
                    }
                }
                let word_id
                for (let key in list) {
                    if (list[key] == 2)
                        word_id = key
                }
                if (this._lab_input.text.length > 0)
                    answard_vo += `"${word_id}":"${this._lab_input.text}"`
                let ticket = ClientConfig.login_key
                let now_method = "survey_question_result"
                let cur_time = String(Math.floor(new Date().getTime() / 1000))
                let sign = md5.hex_md5(String(ticket + cur_time + now_method)).toLowerCase()
                let params = `time=${cur_time}&sign=${sign}&method=${now_method}&role_id=${role_id}&name=${name}&source=${source}&type=${questionnaire_type_}&res={${answard_vo}}`
                local_HttpUtil.HttpPostRequest(ClientConfig.php_questionnaire, params, hand_ind_call_back)
            }, this, true)

            this.InitInputEvent()
        }
        this.CreateSubject = (id) => {
            if (receive_stage_ == 1) return
            let call_func = (question_cfg, answard_cfg) => {
                if (!question_cfg || !answard_cfg)
                    return
                // question_cfg = JSON.parse(question_cfg)
                // answard_cfg = JSON.parse(answard_cfg)
                subject_num_ = local_Util.TableSize(question_cfg)
                this._lab_num.text = `${now_id_}/${subject_num_}`
                for (let key in question_cfg) {
                    let value = question_cfg[key]
                    let type = local_Number(value.select_type)
                    if (local_Number(value.question_id) == id && questionnaire_type_ == local_Number(value.type)) {
                        this._lab_subject.text = `${id}.${value.content}`
                        this.select_scroller.visible = type == 2 ? false : true
                        this._gp_text_input.visible = type == 2 ? true : false
                        if (this._gp_text_input.visible) this._lab_font_num.visible = this._lab_input.text != ""
                        model.type_id_dir[id] = type
                        this.ClearItemList()
                        if (!item_list_)
                            item_list_ = []
                        let i = 1
                        for (let k in answard_cfg) {
                            let vo = answard_cfg[k]
                            if (vo.question_id == id && questionnaire_type_ == local_Number(value.type)) {
                                let item = item_list_[i]
                                if (vo.answer_type == 0) {
                                    if(!this._gp_describe.visible )this._gp_describe.visible = true
                                    if(this._gp_image.visible) this._gp_image.visible = false
                                    if (!item) {
                                        item = new QuestionNaireDescribeItem(this._gp_describe)
                                        item.Load()
                                        item_list_.push(item)
                                    }
                                    let subject = vo.content
                                    let can_select = value.select_type == 0 ? 1 : value.multi_max
                                    min_select_num_ = value.multi_min
                                    item.SetData(type, id, i, subject, can_select)
                                    item.SetPosition(0, (i - 1) * 50)
                                    i++
                                }
                                else if (vo.answer_type == 1) {
                                    if(this._gp_describe.visible )this._gp_describe.visible = false
                                    if(!this._gp_image.visible) this._gp_image.visible = true
                                    if (!item) {
                                        item = new QuestionNaireImageItem(this._gp_image)
                                        item.Load()
                                        item_list_.push(item)
                                    }
                                    min_select_num_ = value.multi_min
                                    let subject = vo.content
                                    item.SetData(id, i, subject,vo.args)
                                    let positionX = i % 2 == 1 ? 0 : 280
                                    let positionY = i / 2 > 1 ? (Math.ceil(i / 2) - 1) * 230 : 0
                                    item.SetPosition(positionX, positionY)
                                    i++
                                }
                            }
                        }
                    }
                }
                this._lab_num.text = `${now_id_}/${subject_num_}`
                this.SetButton()
            }
            let check_version = (data) => {
                let question_cfg, answard_cfg
                let ckeck_question_cfg = (data) => {
                    if (!data) return
                    if (this.use_delete_method) return
                    model.question_cfg = data.filter(item => item.type == questionnaire_type_)
                    question_cfg = data.filter(item => item.type == questionnaire_type_)
                    if (!question_cfg || !answard_cfg) return
                    call_func(question_cfg, answard_cfg)
                }
                let ckeck_answard_cfg = (data) => {
                    if (!data) return
                    if (this.use_delete_method) return
                    model.answard_cfg = data.filter(item => item.type == questionnaire_type_)
                    answard_cfg = data.filter(item => item.type == questionnaire_type_)
                    if (!question_cfg || !answard_cfg) return
                    call_func(question_cfg, answard_cfg)
                }

                if (data) {
                    if (data) {
                        let last_version = cookie_wrapper.GetCookie(GAME_MAIN_VERSION, false)
                        if (last_version != data.version || !model.question_cfg) {
                            cookie_wrapper.SaveCookie(GAME_MAIN_VERSION, String(data.version), false)
                            let [http_path, cfg_path] = LoginModel.GetInstance().GetQuestionPath()
                            local_HttpUtil.HttpLoadJson(http_path, `${cfg_path}/question.json.cfg?v=` + data.version, ckeck_question_cfg, 10000, http_path)
                            local_HttpUtil.HttpLoadJson(http_path, `${cfg_path}/answer.json.cfg?v=` + data.version, ckeck_answard_cfg, 10000, http_path)
                        } else {
                            question_cfg = model.question_cfg
                            answard_cfg = model.answard_cfg
                            ckeck_question_cfg(question_cfg)
                            ckeck_answard_cfg(answard_cfg)
                        }
                    }
                }
            }
            let [http_path, cfg_path] = LoginModel.GetInstance().GetQuestionPath()
            local_HttpUtil.HttpLoadJson(http_path, `${cfg_path}/question_answer.json.cfg.v?v=` + Math.random(), check_version, 10000, http_path)

            //let cfg = res_mgr.GetGameConfigFromCache(this, "ClientUserAgreementTest", true)
        }
        this.ClearItemList = () => {
            if (item_list_ && item_list_.length > 0) {
                for (let obj of item_list_) {
                    obj.DeleteMe()
                }
                item_list_ = null
            }
        }
        this.AutoNextSubject = () => {
            this.ClearItemList()
            now_id_ += 1
            this.CreateSubject(now_id_)
        }
        this.SetButton = () => {
            this._gp_next.visible = now_id_ == subject_num_ ? false : true
            this._gp_hand.visible = now_id_ == subject_num_ ? true : false
            this._gp_last.visible = now_id_ == 1 ? false : true

        }
        this.IsSelect = () => {
            let is_select = false
            let dir = model.GetSelectDir()
            let type_dir = model.type_id_dir
            if (dir && dir[now_id_]) {
                let vo = dir[now_id_]
                let i = 0
                for (let key in vo) {
                    if (vo[key]) {
                        i += 1
                    }
                }
                if (min_select_num_ <= i)
                    is_select = true

            }
            return is_select
        }

        this.InitInputEvent = () => {
            this._lab_input.on(Laya.Event.BLUR, this, () => {
                if (this._lab_input.text == "" && !this._lab_prompt.visible) {
                    this._lab_prompt.visible = true
                    this._lab_font_num.visible = false
                }
                this._lab_input.text != ""
            })
            this._lab_input.on(Laya.Event.FOCUS, this, () => {
                this._lab_prompt.visible = false
                this._lab_font_num.visible = true
            })
            this._lab_input.on(Laya.Event.INPUT, this, () => {
                if (!this._lab_font_num.visible) this._lab_font_num.visible = true
                this._lab_input.text = this._lab_input.text.replace(/\n/ig, "")
                this._lab_font_num.text = `${Math.min(this._lab_input.text.length, 300)}/300`
            })
        }

        this.DeleteMe = () => {
            this.ClearItemList()
            this.ClearUIEffect(this._gp_effect)
            if (item_) {
                item_.DeleteMe()
                item_ = null
            }
            super.DeleteMe()
        }
    }


    public GetComponents() {
        [
            this._img_bg,
            this._gp_item,
            this._gp_effect,
            this._img_red,
            this._gp_bottom,
            this._gp_last,
            this._lab_num,
            this._gp_next,
            this._gp_hand,
            this._gp_question,
            this._lab_subject,
            this.select_scroller,
            this._gp_describe,
            this._gp_image,
            this._gp_text_input,
            this._lab_input,
            this._lab_font_num,
            this._lab_prompt,
            this._gp_receive,
            this._lab_tip,
            this._gp_go,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_gp_item",
                "_gp_effect",
                "_img_red",
                "_gp_bottom",
                "_gp_last",
                "_lab_num",
                "_gp_next",
                "_gp_hand",
                "_gp_question",
                "_lab_subject",
                "select_scroller",
                "_gp_describe",
                "_gp_image",
                "_gp_text_input",
                "_lab_input",
                "_lab_font_num",
                "_lab_prompt",
                "_gp_receive",
                "_lab_tip",
                "_gp_go",
            ])
    }
}
window["QuestionNaireMainView"] = QuestionNaireMainView