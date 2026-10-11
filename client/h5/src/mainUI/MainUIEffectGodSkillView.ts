import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { GlobalTimerQuest, Util } from "../util/Util"
/**降神技能 */
export class MainUIEffectGodSkillView extends BaseView1 {

    is_fresh
   _obj
   time_id
   time_count=0
    public constructor() {
        super()
        this.is_fresh=false
        this.base_file = "mainUI"
        this.layout_file = "MainUIEffectView"
        this.layer_value = Enum_UILayer.Main
        this.destroy_imm = true
        this.time_id = null

        this.load_callback = () => {
            this.display_obj.centerX=0
            this.display_obj.top = Util.GetLiuhaiHeight()+625
            this.LoadSuccess()
        }

        this.open_callback = () => {
        }

        this.destroy_callback = () => {
            if(this.time_id){
                GlobalTimerQuest.CancelQuest(this.time_id)
                this.time_id=null
            }
            this.ClearUIEffect(this._box_eff)
        }
    }



    LoadSuccess() {
        if(this.is_fresh){
            this.SetData(this._obj)
            this.is_fresh=false
            this.SetCountDown()
        }
    }





    SetData(obj?) {
        this._obj=obj
        if(!this.is_loaded){
            this.is_fresh=true
            return
        }else{
            this.SetCountDown()
        }
        this.ClearUIEffect(this._box_eff)
        this.AddUIEffect( this._obj.name,this._box_eff,this._obj.pos||{x:0,y:2},this._obj.scale||1)

    }

    //计时关闭页面  避免页面一直残留
    SetCountDown(){
        this.time_count=80
        if(this.time_id){
            GlobalTimerQuest.CancelQuest(this.time_id)
            this.time_id=null
        }
        let func=()=>{
            this.time_count--
            if(this.time_count<=0){
                this.Close()
            }
        }
        this.time_id = GlobalTimerQuest.AddPeriodQuest(func, 1)
    }

    public DeleteMe(){
        super.DeleteMe()
    }


    _box_eff: Laya.Box
    public GetComponents() {
        [
            this._box_eff,
        ]
            = this.GetChildrenByNames([

                "_box_eff",
            ])
    }
}
window["MainUIEffectGodSkillView"] = MainUIEffectGodSkillView