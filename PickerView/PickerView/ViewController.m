
#import "ViewController.h"

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
// 水果
@property (strong, nonatomic) IBOutlet UILabel *fruitLabell;
//主菜
@property (strong, nonatomic) IBOutlet UILabel *vagetableLabel;
// 饮料
@property (strong, nonatomic) IBOutlet UILabel *drinkLabel;

// 保存plist文件数组
@property (nonatomic,strong) NSArray *foodsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 显示选中框
    self.pickerView.showsSelectionIndicator = NO;
    
    // 在这里设置下方数据刷新部分的初始显示 (即 给pickerview 赋初值)
    for (int i = 0; i < self.foodsArray.count; i++) {
        [self pickerView:self.pickerView didSelectRow:i inComponent:i];
    }
    
}
#pragma mark ----- 懒加载
-(NSArray *)foodsArray
{
    if (nil == _foodsArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Vegetables.plist" ofType:nil];
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:path];
        _foodsArray = tempArray;
    }
    return _foodsArray;
}

#pragma mark ----- 按钮点击事件
- (IBAction)leftItemDidClicked:(id)sender
{
    // 让pickerView选中inComponent列的Row行
        [self.pickerView selectRow:1 inComponent:0 animated:YES];
    
    for (int i = 0; i < self.foodsArray.count; i++) {
        // 获取当前列对应的元素个数
        NSInteger total = [self.foodsArray[i] count];
        // 根据没一列的总数生成随机数
        int randomNumber = arc4random()%total;
        // 获取当前选中的行(即上一次随机移动到的行)
        NSInteger oldRow = [self.pickerView selectedRowInComponent:i];
        // 比较上一次的行号和当前生成的随机数是否相同，如果相同的话则重新生成
        while (oldRow == randomNumber) {
            randomNumber = arc4random()%total;
        }
        // 让pickerView 滚动到指定的某一行
        [self.pickerView selectRow:randomNumber inComponent:i animated:YES];
        // 模拟 通过代码选中某一行
        [self pickerView:self.pickerView didSelectRow:randomNumber inComponent:i];
    }
    
}
#pragma mark ----- UIPickerViewDataSource
// 一共多少行
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.foodsArray.count;
}

// 每行对应的列数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 获取当前行
    NSArray *array = self.foodsArray[component];
    // 返回列数
    return array.count;
}

// 设置每行的数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 获取当前列
    NSArray *arr = self.foodsArray[component];
    
    // 获取当前列对应的数据
    NSString *title = arr[row];
    return title;
}

#pragma mark ----- 设置下方刷新显示的数据
// 当选中了pickerView的某一行的时候调用
// 会将选中的列号和行号作为参数传入
// 只有通过手指选中某一行的时候才会调用
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 获取对应列/行 的数据
    NSString *name = self.foodsArray[component][row];
    // 赋值
    if (0 == component) {
        self.fruitLabell.text = name;
    }else if (1 == component){
        self.vagetableLabel.text = name;
    }else{
        self.drinkLabel.text = name;
    }
}



#pragma mark ----- 隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
