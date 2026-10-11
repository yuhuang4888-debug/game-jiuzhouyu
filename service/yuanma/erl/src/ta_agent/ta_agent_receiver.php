<?php
/**
 * 【模拟测试脚本】
 * 用于本地对数数科技对接有效性做基本检测
 * 将每次接收到的数据，存储到文件中，
 * 通过查看文件数据检验上报数据是否正确
 * @author huangyongxing@yeah.net
 * @date 2021-05-18
 *
 * 上报数据有两种方式，数据都写在requestBody中。
 * 一. form-data
 *   form-data方式，需要传递两个参数：
 *   如果是一条 json 数据：
 *   参数 1：appid=您项目的 APPID
 *   参数 2：data=JSON 数据，UTF-8 编码，需要 urlencode 编码
 *   如果是多条数据：
 *   参数 1：appid=您项目的 APPID
 *   参数 2：data_list=JSONArray 格式的数据，包含多条 JSON 数据，UTF-8 编码，需要 
 *   urlencode 编码
 * 二、raw
 *   整个数据是个JSON对象，包含appid与data字段
 *   单条数据上报时，data字段为一个事件数据
 *   多条数据上报时，data字段为事件数据的列表
 */

/**
 * 此文件放在游戏服代码目录，与ta_agent处于同级目录下
 * 本地部署测试可以使用 php -S 0.0.0.0:8090 开启临时web服务来接收游戏服上报的数据，
 * 开发服务器上将使用.env配置文件，另行部署在独立的目录下，与服务器代码隔离
 * 【游戏服需要使用gm命令设置为internal或local，才能对应进行测试上报】
 * .env文件内容示例（配置返回Array，供查找对应分支的写入路径）：
 * <?php
 * return Array(
 *   'default' => '/tmp',
 *   'develop' => '/data/proj/develop/server/logs',
 *   'pre_stable' => '/data/proj/pre_stable/server/logs',
 * );
 * ?>
 * 要求配置的路径必须存在。产生上报数据时，将会写入到$save_root/thinkingdata目录
 */

// 默认时区
date_default_timezone_set('Asia/Shanghai');

class TAAgentData {

	private static $saveRootConf;
	private static $requestBody;
	private $filepath;
	private $branch;
	private $appid;
	private $datakey;
	private $data;

	public function __construct() {
		self::read_save_config();
	}

	public function save_data() {
		self::read_data(self::$requestBody, $this->appid, $this->datakey, $this->data, $this->branch);
		$this->init_filepath();

		$contentArr = array();
		if(!empty($this->datakey)) {
			// 在请求数据正确的前提下，没有必要打印requestBody，有需要再开启【节省打印数据量】
			// $contentArr[] = "requestBody: " . self::$requestBody;
			$contentArr[] = "appid: {$this->appid}";
			$contentArr[] = "{$this->datakey}: {$this->data}";
		} else {	// 可能是SDK上传，data直接写在requestBody中
			$contentArr[] = "appid: {$this->appid}";
			$contentArr[] = "requestBody: " . self::$requestBody;
		}
		$content = join("\n", $contentArr);
		self::save_file($this->filepath, $content);
		echo  $this->appid;
	}

	/**
	 * 获取存储路径配置
	 */
	private static function read_save_config() {
		if(file_exists(".env")) {
			// 判断网站根路径下是否存在.env文件，如果有，从中读取配置的路径
			$saveRootConf = @require_once(".env");
			if( !empty($saveRootConf) && is_array($saveRootConf) ) {
				self::$saveRootConf = $saveRootConf;
			} else {
				die('error save root config [1]');
			}
		} else {
			// 配置文件不存在，默认写入到 dirname(dirname( __DIR__ )) . "/logs/thinkingdata"
			$saveRoot = dirname(dirname( __DIR__ )) . "/logs";
			self::$saveRootConf = Array('default' => $saveRoot);
		}
	}

	private function init_filepath() {
		if(!empty(self::$saveRootConf) && is_array(self::$saveRootConf) ) {
			$conf = &self::$saveRootConf;
			if(!empty($this->branch)) {
				$saveRoot = isset($conf[$this->branch])?$conf[$this->branch]:'';
			}
			if(empty($saveRoot)) {
				$saveRoot = isset($conf['default'])?$conf['default']:'';
			}
			if(!empty($saveRoot) && is_dir($saveRoot)) {
				// 如果使用 trim 则只会在PHP -S 启动目录下 创建对应的目录，而不是指定去其他目录
				// $saveParent = trim($saveRoot, '/') . '/thinkingdata';
                $saveParent = $saveRoot . '/thinkingdata';
			} else {
				die('save root path not exists');
			}
		} else {
			die('error save root config [2]');
		}
		// 日志文件按日期划分
		$fileBasename = date("Y-m-d");
		// $subPath = substr($fileBasename,0,7);
		// $saveParent = "{$saveParent}/{$subPath}";
		if(!is_dir($saveParent)) {
			@mkdir($saveParent, 0777, true);
		}
		$filepath = "{$saveParent}/{$fileBasename}.log";
		$this->filepath = $filepath;
	}

	/**
	 * read data
	 */
	public static function read_data(&$requestBody, &$appid, &$datakey, &$data, &$branch) {
		// raw requestBody
		$requestBody = @file_get_contents('php://input');
		// appid
		$appid = isset($_REQUEST['appid'])?$_REQUEST['appid']:"";
		// data
		if(isset($_REQUEST['data'])) {
			$datakey = 'data';
			$data = $_REQUEST['data'];
		} elseif(isset($_REQUEST['data_list'])) {
			$datakey = 'data_list';
			$data = $_REQUEST['data_list'];
		} else {
			// 【只解析form-data提交模式的数据，raw模式不解析数据，查证raw requestBody即可】
			$datakey = '';
			$data = '';
		}
		$branch = isset($_REQUEST['branch'])?$_REQUEST['branch']:'';
	}

	/**
	 * save file
	 */
	public static function save_file($file, $data) {
		$time = date("Y-m-d H:i:s");
		file_put_contents("$file", "[{$time}] -----------------------------------------------\n{$data}\n", FILE_APPEND);
	}

	public static function is_json($str){
		$data = @json_decode($str);
		return !is_null($data);
	}

}

$ta = new TAAgentData();
$ta->save_data();

?>
