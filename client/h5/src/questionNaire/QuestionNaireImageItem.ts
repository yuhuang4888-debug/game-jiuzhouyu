import { BaseItem1 } from "../common/BaseItem1";
import { ResManager } from "../common/ResManager";
import { QuestionNaireModel } from "../commonModel/QuestionNaireModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class QuestionNaireImageItem extends BaseItem1 {

    _img_select: Laya.Image
    _img_not_select: Laya.Image
    _lab_subject: Laya.Label
    _img_subject: Laya.Image
    need_refresh_data


    id
    index
    subject
    url
    model
    can_change = true
    public constructor(parent) {
        super(parent)
        this.base_file = "questionNaire"
        this.layout_file = "QuestionNaireImageItem"
        this.need_refresh_data = false
        this.model = QuestionNaireModel.GetInstance()
        this.load_callback = () => {
            this.LoadSuccess()
            this.InitEvent()
        }

    }
    private LoadSuccess() {
        if (this.need_refresh_data) {
            this.need_refresh_data = false
            this.UpdataView()
        }
    }

    public SetData(id, index, subject,url) {
        this.id = id
        this.index = index
        this.subject = subject
        this.url = url
        if (this.is_loaded)
            this.UpdataView()
        else
            this.need_refresh_data = true
    }

    public UpdataView() {
        let dir = this.model.GetSelectDir()
        this._img_select.visible = dir && dir[this.id] && dir[this.id][this.index] ? true : false
        this._img_not_select.visible = dir && dir[this.id] && dir[this.id][this.index] ? false : true
        this._lab_subject.text = this.subject
        ResManager.GetInstance().SetTexture(this, this._img_subject,GameResPath.GetIcon("questionNaire",this.url))
    }
    public InitEvent() {
        this.BindEvent(this.model, QuestionNaireModel.CHANGNE_SELECT_STAGE_SINGLE, (id, index) => {
            if (id != this.id) return
            if (id == this.id && this.index == index) return
            this.model.SetSelectDir(this.id, this.index, false)
            this._img_select.visible = false
            this._img_not_select.visible = true
        })
        Util.AddClickEvent(this._img_select, () => {
            if (!this.can_change) return
            this._img_not_select.visible = true
            this._img_select.visible = false
            this.model.SetSelectDir(this.id, this.index, false)
        }, this, true)
        Util.AddClickEvent(this._img_not_select, () => {
            if (!this.can_change) return
            this.model.Fire(QuestionNaireModel.CHANGNE_SELECT_STAGE_SINGLE, this.id, this.index)
            this._img_select.visible = true
            this._img_not_select.visible = false
            this.model.SetSelectDir(this.id, this.index, true)
            this.can_change = false
            setTimeout(() => {
                this.model.Fire(QuestionNaireModel.AUTO_NEXT_SUBJECT, this.id)
            }, 500)
        }, this, true)
    }

    public DeleteMe() {
        super.DeleteMe()
    }


    public GetComponents() {
        [
            this._img_select,
            this._img_not_select,
            this._lab_subject,
            this._img_subject,
        ]
            = this.GetChildrenByNames([

                "_img_select",
                "_img_not_select",
                "_lab_subject",
                "_img_subject",
            ])
    }
}
window["QuestionNaireImageItem"] = QuestionNaireImageItem