import { table } from "../common/table";
import { EventDispatcher } from "../util/EventDispatcher";

export const SvipDefine = {
    CONTENT_AD: 1,   //广告语
    CONTENT_PIC: 2,  //图片
    CONTENT_PRI: 3, //特权内容
    CONTENT_CON: 4  //联系方式
}
window["SvipDefine"] = SvipDefine


export class SvipMainModel extends EventDispatcher {
    static Instance: SvipMainModel
    open_act_id
    server_content_list
    GetOpenActId
    GetContentList
    AnalysisListData
    act_data_dic

    

    public constructor() {
        super();
        if (SvipMainModel.Instance) {
            return
        }
        SvipMainModel.Instance = this
        this.open_act_id = 0;   //当前开放的活动ID
        this.server_content_list = []; 
        this.act_data_dic = {}

        this.GetOpenActId = () => {
            return this.open_act_id
        }

        this.AnalysisListData = () => {
            if(!this.server_content_list){
                return
            }
            for (let key in this.server_content_list) {
                let value = this.server_content_list[Number(key)]
                if(value.content_list.length > 1){
                    let list = []
                    for (let idx in value.content_list) {
                        let key_str = `${value.type}@${value.content_list[Number(idx)].content_id}`
                        table.insert(list, key_str)
                    }
                    this.act_data_dic[value.type] = list
                }
                else{
                    let key_str = `${value.type}@${value.content_list[0].content_id}`
                    this.act_data_dic[value.type] = key_str
                }
            }
            return this.act_data_dic
        }

        this.GetContentList = () => {
            let dic = this.AnalysisListData()
            return dic
        }
    }

    public static GetInstance() {
		if (!SvipMainModel.Instance) {
			SvipMainModel.Instance = new SvipMainModel()
		}
		return SvipMainModel.Instance
	}
}
window["SvipMainModel"] = SvipMainModel