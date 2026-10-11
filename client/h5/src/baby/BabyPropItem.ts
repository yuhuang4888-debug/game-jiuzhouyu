import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager"

export class BabyPropItem extends BaseItem1 {
    color
    SetData
    cur
    next
    spe
    public constructor(parent, color?) {
        super(parent)
        this.base_file = "baby"
        this.layout_file = "BabyPropItem"
        this.color = color
        let local_Math = Math
        let word_mgr = WordManager
        let needRefresh = false
        this.load_callback = function () {

            if (needRefresh) {
                this.SetData(this.cur, this.next, this.spe)
                needRefresh = undefined
            }

            if (this.color) {
                this.nameLb.color = "#4a3a32"
                this.nextLb.color = "#4aaf00"
            }

        }

        this.SetData = (cur, next, spe?) => {
            this.cur = cur
            this.next = next
            this.spe = spe
            if (this.is_loaded) {
                this.nameLb.style.fontSize = 20
                this.nameLb.style.color = "#663915"
                this.nameLb.style.wordWrap = false
                if (spe) {
                    if (next) {
                        let value = next[1][0][1]
                        if (cur && cur[1]) {
                            value -= cur[1][0][1] || 0
                        } else {
                            cur[`1`] = [{ "1": 0 }]
                        }
                        this.nextLb.text = `+${local_Math.round(value / 100)}%`
                        this.arrow.visible = true
                    } else {
                        this.nextLb.text = ``
                        this.arrow.visible = false
                    }
                    if (cur) {
                        this.nameLb.innerHTML = `${word_mgr.GetBabyPos(cur[0])}属性<font color='#d15e00'>+${local_Math.round(cur[1][0][1] / 100)}%</font>`
                    }
                    this.arrow.x = 207
                    this.nextLb.x = 242
                    // this.nameLb.color = "#E92A2A"
                } else {
                    if (this.color) {
                        // this.nameLb.color = "#4a3a32"
                        this.arrow.x = 207
                        this.nextLb.x = 242
                    } else {
                        // this.nameLb.color = "#FFFFFF"
                    }
                    if (next) {
                        let value = next[1]
                        if (cur) {
                            value -= cur[1] || 0
                        }
                        this.nextLb.text = `${word_mgr.ConvertToPercentValue(next[0], value)}`
                        this.arrow.visible = true
                    } else {
                        this.nextLb.text = ``
                        this.arrow.visible = false
                    }
                    if (cur) {
                        this.nameLb.innerHTML = `${word_mgr.GetProperties(cur[0])}:<font color='#d15e00'>${word_mgr.ConvertToPercentValue(cur[0], cur[1])}</font>`
                    }
                }
            } else {
                needRefresh = true
            }
        }
    }

    
    nameLb: Laya.HTMLDivElement
    nextLb: Laya.Label
    arrow: Laya.Image
    public GetComponents() {
        [
            this.nameLb,
            this.nextLb,
            this.arrow,
        ]
            = this.GetChildrenByNames([

                "nameLb",
                "nextLb",
                "arrow",
            ])
    }
}
window["BabyPropItem"] = BabyPropItem