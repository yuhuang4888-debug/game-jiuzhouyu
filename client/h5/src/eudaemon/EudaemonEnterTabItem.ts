import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { BossModel } from "../commonModel/BossModel"
import { Util } from "../util/Util"

export class EudaemonEnterTabItem extends BaseItem1 {

    UpdateRed
    boss_model:BossModel
    data
    index
    callback
    need_refresh=false
    seleted=false
    seleted_fresh=false
    index_chace
	WIDTH = 130
    HEIGT = 62

    public constructor(parent) {
        super(parent)

        this.base_file = "eudaemon"
        this.layout_file = "EudaemonEnterTabItem"
        this.boss_model=BossModel.GetInstance()
        this.load_callback = () => {


            this.BindEvent(this.boss_model, BossModel.BOSS_EUDA_REMIAN_UPDATE, (scmd?) => {
                if (scmd&&this.data.boss_type == scmd.boss_type) {
                    this.UpdateRed()
                } }
            )

            Util.AddClickEvent(this._img_bg,()=>{
                if(this.callback)this.callback(this.index,true)
            },this,false)
    

            if( this.need_refresh){
                this.need_refresh=false
                this.SetData(this.data,this.index,this.callback)
            }

            if(this.seleted_fresh){
                this.SetSelect(this.index_chace)
                this.seleted_fresh=false
            }
        }

        this.UpdateRed=()=>{
            if(!this.data)return
            if(this.data.floor==0){
                this._img_shop_red.visible=this.boss_model.CheckBossAbyssLayer(this.data.floor,BossModel.BossType.holy_wuxian)
            }else{
                let cross_server_boss_info = BossModel.GetInstance().GetBossTypeInfo(BossModel.BossType.holy)
				let left_time = cross_server_boss_info.max_tired - cross_server_boss_info.tired
                this._img_shop_red.visible=this.boss_model.CheckBossAbyssLayer(this.data.floor,BossModel.BossType.holy)&&left_time>0
            }
            
        }

    }


    public SetData(data,index,callback) {
		if (!data)return
        this.data =data
        this.index = index
        this.callback = callback
        if(this.is_loaded){
            this._img_shop_red.visible=false
            this._lb_name.text = (this.data.floor == 0 ? "无限" : WordManager.NumConvertStage(this.data.floor)) + "层"
            this.UpdateRed()
            this.need_refresh=false
        }else{
            this.need_refresh=true
        }

	}



    public SetSelect(index) {
        let seleted = this.index ==index
        this.index_chace = index

        if(this.is_loaded){
            if ( seleted) {
                this._lb_name.color = "#9b572f"
                ResManager.GetInstance().SetImageSprite(this, this._img_bg, "eudaemon", "ui_kfa_00101")
            } else {
                this._lb_name.color = "#ffffff"
                ResManager.GetInstance().SetImageSprite(this, this._img_bg, "eudaemon", "ui_button_mid_1")
            }
        }else{
            this.seleted_fresh =true
        }
   
    }

    public GetIndex(){
        return this.index
    }

_img_bg:Laya.Image
_lb_name:Laya.Label
_img_shop_red:Laya.Image
public GetComponents() {
[
this._img_bg,
this._lb_name,
this._img_shop_red,
]
 = this.GetChildrenByNames([

"_img_bg",
"_lb_name",
"_img_shop_red",
])
}
}
 window["EudaemonEnterTabItem"]= EudaemonEnterTabItem