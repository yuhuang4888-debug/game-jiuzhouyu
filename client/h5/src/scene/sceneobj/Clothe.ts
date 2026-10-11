import { BaseClass } from "../../common/BaseClass"
import { ResManager } from "../../common/ResManager"
import { LOAD_QUEUE } from "../../util/DeclareGlobalVar"
import { GameError } from "../../util/GameError"
import { GameResPath } from "../../util/GameResPath"
import { SetMaterialTexture, Util } from "../../util/Util"

export class Clothe extends BaseClass {
	res_path

	public constructor(material?, res?, loadback?) {
		super()
		this.LoadTexture(material, res, loadback)
	}
		

	public LoadTexture(material?, res?, loadback?) 
	{
		this.res_path = res
		let call_back = (texture?) => {
			if (this.use_delete_method) {
				return
			}
			if (texture && material) {
				if (texture) {
					SetMaterialTexture(material, texture)
				} else {
					GameError.Instance.SendErrorToPHP("加载时装贴图 " + res + " 为空")
				}
			}

			if (loadback) {
				loadback()
			}
		}

	
		let url = GameResPath.GetFashionPath(res)
		if (Util.use_ktx) {
            url = url.substring(0, url.lastIndexOf(".")) + ".ktx"
        }
		ResManager.GetInstance().GetResByUrl(this.hashCode, url, call_back, this, Laya.Loader.IMAGE, LOAD_QUEUE.MIDDLE, false);
	}
}


window["Clothe"] = Clothe