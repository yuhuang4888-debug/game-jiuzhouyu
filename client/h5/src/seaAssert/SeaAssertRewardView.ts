import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Util } from "../util/Util"
import { SeaAssertRewardItem } from "./SeaAssertRewardItem"

export class SeaAssertRewardView extends BaseView1 {
    InitEvent
    LoadSuccess
    initItem

    public constructor() {
        super()

        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertRewardView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.back_login_toClose = true;
        let _model: SeaHegemonyModel = SeaHegemonyModel.GetInstance()
        let item_ac: LoopScrowViewMgr = null

        this.preload_server_config = {
            config_sea_craft_daily_task: false
        }

        this.load_callback = () => {

            this.LoadSuccess()
            this.InitEvent()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this._img_close, () => {
                    this.Close()
                },
                this,
                true
            )
            this.BindEvent(
                _model,
                SeaHegemonyModel.ASSERT_TASK_DATA, () => {
                    this.initItem()
                }
            )
        }

        this.LoadSuccess = () => {
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("common", "uisksh_108"))
        }

        this.open_callback = () => {
            _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18712)
        }

        this.close_callback = () => {
            if (item_ac) {
                item_ac.DeleteMe();
                item_ac = null
            }
        }

        this.initItem = () => {
            let config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_craft_daily_task", false);
            let data = []
            for (let key in config) {
                // [ts2lua]config下标访问可能不正确
                let task = config[key]
                let task_data = _model.getTaskData(task.id)
                if (task_data) {
                    // [ts2lua]task下标访问可能不正确
                    task["task_data"] = task_data
                } else {
                    // [ts2lua]task下标访问可能不正确
                    task["task_data"] = null
                }
                table.insert(data, task)
            }
            table.sort(data, (a?, b?) => {
                if (a.task_data && b.task_data && a.task_data.status != b.task_data.status) {
                    return a.task_data.status < b.task_data.status
                }
                return false
            })
            if (!item_ac) {
                item_ac = new LoopScrowViewMgr()
                item_ac.SetData(this.Content, SeaAssertRewardItem, data, LoopScrCon.Vertical)
            } else {
                item_ac.replaceAll(data)
            }
        }
    }


    public DeleteMe() {
        super.DeleteMe();


    }

    _Image1: Laya.Image
    _Image2: Laya.Image
    _img_title: Laya.Image
    _img_close: Laya.Image
    _Image3: Laya.Image
    Content: Laya.List
    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._img_title,
            this._img_close,
            this._Image3,
            this.Content,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "_img_title",
                "_img_close",
                "_Image3",
                "Content",
            ])
    }
}
window["SeaAssertRewardView"] = SeaAssertRewardView