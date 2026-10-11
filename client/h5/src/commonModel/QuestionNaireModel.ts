import { EventName } from "../common/EventName";
import { LoginModel } from "../login/LoginModel";
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { EventDispatcher } from "../util/EventDispatcher";
import { ActivityIconManager } from "./ActivityIconManager";
import { CustomActivityDefine } from "./CustomActivityDefine";
import { CustomActivityModel } from "./CustomActivityModel";
import { RoleManager } from "./RoleManager";

export class QuestionNaireModel extends EventDispatcher {
    static Instance: QuestionNaireModel
    static CHANGNE_SELECT_STAGE = "CHANGNE_SELECT_STAGE"
    static CHANGNE_SELECT_STAGE_SINGLE = "CHANGNE_SELECT_STAGE_SINGLE"
    static AUTO_NEXT_SUBJECT = "AUTO_NEXT_SUBJECT"
    static UPDATE_VIEW = "UPDATE_VIEW"
    static CLOSE_QUESTIONNAIRE_VIEW = "CLOSE_QUESTIONNAIRE_VIEW"
    static QUESTIONNAIRE_ACT_BASE_TYPE = 90
    public select_dir = {}
    public word_dir = {}
    public type_id_dir = {}
    public question_cfg
    public answard_cfg
    public questionnaire_type
    public red_status

    SetSelectDir
    GetSelectDir
    SetWordDir
    GetWordDir
    SetLevel
    SetIcon
    JuagePlayName
    public constructor() {
        super()
        let activity_icon_mgr = ActivityIconManager.GetInstance(),
            local_GlobalEventSystem = GlobalEventSystem,
            REFRESH_ACTIVITY_ICON_RED_DOT = EventName.REFRESH_ACTIVITY_ICON_RED_DOT,
            can_open_lv = false

        this.SetSelectDir = (id, select_index, select) => {
            if (!this.select_dir[id] || typeof(this.select_dir[id]) != "object"){
                this.select_dir[id] = {}
            }
            this.select_dir[id][select_index] = select
        }
        this.GetSelectDir = () => {
            return this.select_dir
        }
        this.SetWordDir = (id, word) => {
            this.word_dir[id] = word
        }
        this.GetWordDir = () => {
            return this.word_dir
        }
        this.SetLevel = (vo, need_send) => {
            if (!vo || !this.JuagePlayName(vo)) return
            let condition = ErlangParser.GetInstance().Parse(vo.condition)
            let role_lv
            if (condition[0][0] == "role_lv")
                role_lv = condition[0][1]
            if (condition[1][0] == "questionnaire")
                this.questionnaire_type = Number(condition[1][1])
            let lv = RoleManager.GetInstance().GetMainRoleVo().level
            if (lv >= role_lv)
                can_open_lv = true
            if (need_send){
                if(this.question_cfg){
                    this.answard_cfg = this.question_cfg = null
                    this.select_dir = this.word_dir = this.type_id_dir = {}
                }
                CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33104, 90, this.questionnaire_type)
            }    
        }
        this.SetIcon = (vo) => {
            if (!vo||vo.reward_list.length==0) return
            let stage = vo.reward_list[0].status
            this.red_status = stage == 1 ? true : false
            let icon = activity_icon_mgr.getIconInfo("90@331");
            if (!ClientConfig.open_questionnaria) {
                if (icon)
                    activity_icon_mgr.deleteIcon("90@331")
                return
            }
            if (can_open_lv && stage != 2 && !icon) {
                activity_icon_mgr.addIcon("90@331")
                local_GlobalEventSystem.Fire(REFRESH_ACTIVITY_ICON_RED_DOT, "90@331", true)
            }
            if ((!can_open_lv || stage == 2) && icon)
                activity_icon_mgr.deleteIcon("90@331")
            if (icon)
                local_GlobalEventSystem.Fire(REFRESH_ACTIVITY_ICON_RED_DOT, "90@331", this.red_status)
            this.Fire(QuestionNaireModel.UPDATE_VIEW)
        }

        this.JuagePlayName = (vo) =>{
            let b = vo.base_type
            let s = vo.sub_type
            let cond = CustomActivityModel.GetInstance().GetActCondition(b, s,"info")
            let play_name = LoginModel.GetInstance().plat_name || ClientConfig.plat_name;
            let is_can_add = false
            if(cond){
                if(cond.source_list && cond.source_list.length>0){
                    for (let item of cond.source_list) {
                        if (play_name == item) {
                            is_can_add = true
                            break
                        }
                    }
                }else{
                    is_can_add = true
                }
            }
            return is_can_add
        }
    }
    
    public static GetInstance() {
        if (!QuestionNaireModel.Instance) {
            QuestionNaireModel.Instance = new QuestionNaireModel();
        }
        return QuestionNaireModel.Instance;
    }
}