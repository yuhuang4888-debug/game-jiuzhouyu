import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { QuestionNaireModel } from "../commonModel/QuestionNaireModel"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"

export class QuestionNaireDescribeItem extends BaseItem1 {
    _img_select: Laya.Image
    _img_not_select: Laya.Image
    _lab_question: Laya.Label

    type
    id
    index
    subject
    need_refresh_data
    can_select
    model
    can_change = true
    public constructor(parent) {
        super(parent)
        this.base_file = "questionNaire"
        this.layout_file = "QuestionNaireDescribeItem"
        this.need_refresh_data = false
        this.model = QuestionNaireModel.GetInstance()
        this.load_callback = () => {
            this.LoadSuccess()
        }

    }
    private LoadSuccess = () => {
        if (this.need_refresh_data) {
            this.need_refresh_data = false
            this.UpdataView()
        }
    }

    public SetData(type, id, index, subject, can_select) {
        this.type = type
        this.id = id
        this.index = index
        this.subject = subject
        this.can_select = can_select
        if (this.is_loaded)
            this.UpdataView()
        else
            this.need_refresh_data = true
    }

    public UpdataView() {
        this.InitEvent()
        let dir = this.model.GetSelectDir()
        this._img_select.visible = dir && dir[this.id] && dir[this.id][this.index] ? true : false
        this._img_not_select.visible = dir && dir[this.id] && dir[this.id][this.index] ? false : true
        let select_url = Number(this.type) == 0 ? "uiwjdc_010" : "uiwjdc_013"
        let not_select_url = Number(this.type) == 0 ? "uiwjdc_011" : "uiwjdc_012"
        ResManager.GetInstance().SetImageSprite(this, this._img_select, "questionNaire", select_url)
        ResManager.GetInstance().SetImageSprite(this, this._img_not_select, "questionNaire", not_select_url)
        this._lab_question.text = this.subject
    }

    public InitEvent() {
        if (this.type == 1) {
            this.BindEvent(this.model, QuestionNaireModel.CHANGNE_SELECT_STAGE, (id, index) => {
                if (id != this.id) return
                let dir = this.model.GetSelectDir()
                let select_num = 0
                if (dir && dir[id]) {
                    for (let key in dir[id]) {
                        let value = dir[id][key]
                        if (value)
                            select_num++
                    }
                }
                if (select_num < this.can_select && index == this.index) {
                    this._img_select.visible = true
                    this._img_not_select.visible = false
                    select_num++
                    this.model.SetSelectDir(this.id, index, true)
                }
                if (select_num >= this.can_select) {
                    this.can_change = false
                    setTimeout(() => {
                        this.model.Fire(QuestionNaireModel.AUTO_NEXT_SUBJECT, this.id)
                    }, 500)
                }
            })
        }
        else {
            this.BindEvent(this.model, QuestionNaireModel.CHANGNE_SELECT_STAGE_SINGLE, (id, index) => {
                if (id != this.id) return
                if (id == this.id && this.index == index) return
                this.model.SetSelectDir(this.id, this.index, false)
                this._img_select.visible = false
                this._img_not_select.visible = true
            })
        }

        Util.AddClickEvent(this._img_select, () => {
            if (!this.can_change) return
            this._img_not_select.visible = true
            this._img_select.visible = false
            this.model.SetSelectDir(this.id, this.index, false)
        }, this, true)
        Util.AddClickEvent(this._img_not_select, () => {
            if (!this.can_change) return
            if (this.type == 0) {
                this.model.Fire(QuestionNaireModel.CHANGNE_SELECT_STAGE_SINGLE, this.id, this.index)
                this._img_select.visible = true
                this._img_not_select.visible = false
                this.model.SetSelectDir(this.id, this.index, true)
                this.can_change = false
                setTimeout(() => {
                    this.model.Fire(QuestionNaireModel.AUTO_NEXT_SUBJECT, this.id)
                }, 500)
            }
            else {
                let select_num = 0
                let dir = this.model.GetSelectDir()
                let id = this.id
                if (dir && dir[id]) {
                    for (let key in dir[id]) {
                        let value = dir[id][key]
                        if (value)
                            select_num++
                    }
                }
                if (select_num >= this.can_select){
                    Message.show("当前题目已达到最大选项数")
                }  
                this.model.Fire(QuestionNaireModel.CHANGNE_SELECT_STAGE, this.id, this.index)
            }
        }, this, true)
    }

    public DeleteMe() {
        super.DeleteMe()
    }

    public GetComponents() {
        [
            this._img_select,
            this._img_not_select,
            this._lab_question,
        ]
            = this.GetChildrenByNames([

                "_img_select",
                "_img_not_select",
                "_lab_question",
            ])
    }
}
window["QuestionNaireDescribeItem"] = QuestionNaireDescribeItem