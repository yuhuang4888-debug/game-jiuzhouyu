import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { MapModel } from "../commonModel/MapModel"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { GlobalEventSystem, LogicRealRatio_X, LogicRealRatio_Y } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { GameResPath } from "../util/GameResPath"
import { PlatformManager } from "../PlatformManager"
import { MapEnterView } from "./MapEnterView"

export class AreaMapMonItem extends BaseItemRenderer {

    public  WIDTH = 134
	public  HEIGT = 166

    public mon_icon: Laya.Image;
    public desc: Laya.Label;
    public click_bg: Laya.Box;
    public level
    private model: MapModel;
    private cfg_finish = false;
    _Image1
    _Image2

    _Image1_skin
    constructor() {
        super();
        this.base_file = "map"
        this.layout_file = "AreaMapMonItem"
        // this.skinName = "resource/game/map/exml/AreaMapMonItemExml.exml";
        // this.model = MapModel.GetInstance();
        // this.is_delay_callback = false;
        // let click_bg_fun = () => {
        //     if (this.data) {s
        //         if (this.data) {
        //             let call_fun = () => {
        //                 if (this.model.CheckOpenAutoFight()) {
        //                     AutoFightManager.GetInstance().SetAutoFight(true);
        //                 }
        //             };
        //             Scene.GetInstance().MainRoleMove(new Vector2(this.data.x / LogicRealRatio_X, this.data.y / LogicRealRatio_Y), 3, call_fun);
        //         }
        //         GlobalEventSystem.Fire(EventName.CLOSE_MAP_VIEW, MapEnterView);
        //     }
        // };
        //Util.AddClickEvent(this.click_bg, click_bg_fun, this, true);
        this.Load()

    }

    public load_callback(){
        this._Image1.skin=this._Image1_skin
    }
    public DeleteMe() {
        super.DeleteMe();
    }
    public createChildren(): void {
        super.createChildren();
    }
    public dataChanged(): void {
        if (super.dataChanged()) {
            // if (PlatformManager.IsEyouEnPlatform()) {
            //     this.desc.wordWrap = true;
            // }
            if (this.data.is_npc) {
                let npc_cfg = Config.PRELOAD_SERVER_CONFIG.config_npc[this.data.mon_id];
                if (npc_cfg) {
                    ResManager.GetInstance().SetTexture(this, this.mon_icon, GameResPath.GetMonsterHeadPath(npc_cfg.image));
                    // this.mon_icon.skin=GameResPath.GetMonsterHeadPath(npc_cfg.image)
                    this.desc.text = npc_cfg.name;
                }
            }
            else {
                let cfg_data = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.data.mon_id, false);
                if (cfg_data) {
                    ResManager.GetInstance().SetTexture(this, this.mon_icon, GameResPath.GetMonsterHeadPath(cfg_data.icon));
                    // this.mon_icon.skin=GameResPath.GetMonsterHeadPath(cfg_data.icon)
                    this.level.text=`Lv.${this.data.lv}`;
                    this.desc.text = `${cfg_data.name}`;
                }
            }
            if(PlatformManager.IsEyouEnPlatform()){
                this.desc.fontSize = 18
            }
        }
        if(this.selected){
            if(this.is_loaded){
                this._Image1.skin="resource/game/map/texture/uidu_009b.png"
            }else{
                this._Image1_skin="resource/game/map/texture/uidu_009b.png"
            }
        }else{
            if(this.is_loaded){
                this._Image1.skin="resource/game/map/texture/uidu_009.png"
            }else{
                this._Image1_skin="resource/game/map/texture/uidu_009.png"
            }
        }
    }

    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this.mon_icon,
            this.desc,
            this.click_bg,
            this.level
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "mon_icon",
                "desc",
                "click_bg",
                "level"
            ])
    }
}
window["AreaMapMonItem"] = AreaMapMonItem