import { EventDispatcher } from "../../util/EventDispatcher";
import { Scene } from "../Scene";
import { SceneManager } from "../SceneManager";
import { NameBoard } from "../sceneboard/NameBoard";
import { Enum_UILayer, LayerManager } from "../../common/LayerManager";

export class NameBoardManager extends EventDispatcher {
	static Instance
	parent
	name_board_dic
	scene
	scene_mgr
	public constructor( ){ 
		super() 
		this.name_board_dic = {}	//名字列表
		this.scene = Scene.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()
		this.parent = LayerManager.GetInstance().GetUILayer(Enum_UILayer.NameBoard)
	}
	public static GetInstance( ){ 
		
		if (!NameBoardManager.Instance) {
			NameBoardManager.Instance = new NameBoardManager()
		}
		return NameBoardManager.Instance
	}

	public CreateNameBoard(parent?, attach_target?){ 
		
		let nameboard =  new NameBoard(parent || this.parent)
		nameboard.Load()
		nameboard.attach_target = attach_target
		// this.AddNameBoard(nameboard, attach_target)
		return nameboard
	}

	// public AddNameBoard(nameboard:NameBoard, attach_target?){ 
	// 	this.name_board_dic[nameboard.hashCode] = {attach_target:attach_target, nameboard:nameboard}
	// }

	// public RemoveNameBoard(nameboard?:NameBoard){ 
	// 	delete this.name_board_dic[nameboard.hashCode]
	// }

	//主角移动，摄像机移动，更新全部  弃用
	public UpdateAllNameBoard( ){ 
		for (let hashCode in this.name_board_dic) {
			var obj = this.name_board_dic[hashCode]
			if (obj.nameboard.visible) {
				obj.nameboard.UpdatePos()
			}
		}
	}


}
window["NameBoardManager"] = NameBoardManager