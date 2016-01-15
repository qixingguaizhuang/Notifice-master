//
//  ViewController.m
//  Notifice
//
//  Created by sp on 16/1/14.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "ViewController.h"

#define WIDTH  self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain)UICollectionView *collectionView;
@property (nonatomic, retain)UICollectionView *collectionForMenu;
@property (nonatomic, retain)UIView *redLine;
@property (nonatomic, retain)UIButton *buttonForMenu;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLineOfRed];
    [self creatCollectionView];
    [self registerAsObserver];
    [self createButtonForMenu];
}


- (void)createLineOfRed{

    self.redLine = [[UIView alloc]initWithFrame:CGRectMake(0, 50, WIDTH/5, 2)];
    self.redLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redLine];
}

- (void)creatCollectionView{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake(WIDTH, HEIGHT - 52);
    
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
   
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 52, WIDTH, HEIGHT-52) collectionViewLayout:flowLayout];
    
    self.collectionView.backgroundColor = [UIColor brownColor];
    self.collectionView.pagingEnabled = YES;
    
    [self.view addSubview:self.collectionView];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    /** 注册*/
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"poolForcell"];

}

// 箭头按钮创建

- (void)createButtonForMenu{

    self.buttonForMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonForMenu.frame = CGRectMake(WIDTH - 50, 20, 40, 30);
    [self.buttonForMenu setImage:[UIImage imageNamed:@"j" ]forState:UIControlStateNormal];
    self.buttonForMenu.backgroundColor = [UIColor clearColor];
    [self.buttonForMenu addTarget:self action:@selector(MenuForAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.buttonForMenu];

}

// 点击箭头按钮创建 collectionMenu 视图

- (void)MenuForAction:(UIButton *)button{
    
    
    button.selected = !button.selected;
    
    if (button.isSelected){

        if (!self.collectionForMenu) {
            
            UICollectionViewFlowLayout *flowlayOut = [[UICollectionViewFlowLayout alloc] init];
            flowlayOut.itemSize = CGSizeMake(70, 30);
            
            flowlayOut.minimumLineSpacing = 10;
            flowlayOut.minimumInteritemSpacing = 10;
            
            flowlayOut.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
            
            
            self.collectionForMenu = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 52, WIDTH, 0) collectionViewLayout:flowlayOut];
            self.collectionForMenu.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:self.collectionForMenu];
            
            self.collectionForMenu.delegate = self;
            self.collectionForMenu.dataSource = self;
            
            [self createLongpress];
            [self.collectionForMenu registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"poolForMenu"];
      
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.collectionForMenu.frame = CGRectMake(0, 52, WIDTH, HEIGHT /4);
            self.buttonForMenu.transform = CGAffineTransformMakeRotation(0);
            button.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];

    }else {
   
       [UIView animateWithDuration:0.2 animations:^{
       
        self.collectionForMenu.frame = CGRectMake(0, 52, WIDTH, 0);
        button.transform = CGAffineTransformMakeRotation(0);
        }];

    }
}


// 长按按钮移动 collection

- (void)createLongpress{
    

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
 
    [self.collectionForMenu addGestureRecognizer:longPress];
    
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    

    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
    
        {
            NSIndexPath *beginIndexPath =  [self.collectionForMenu indexPathForItemAtPoint:[longPress locationInView:self.collectionForMenu]];
            if (beginIndexPath == nil) {
                return;
            }
            
            [self.collectionForMenu beginInteractiveMovementForItemAtIndexPath:beginIndexPath];
            break;
        }
            case UIGestureRecognizerStateChanged:
        {
        
            [self.collectionForMenu updateInteractiveMovementTargetPosition:[longPress locationInView:self.collectionForMenu]];
            break;
        }
            case UIGestureRecognizerStateEnded:
        {
            [self.collectionForMenu endInteractiveMovement];
            break;
        }
            
        default:
            [self.collectionForMenu cancelInteractiveMovement];
            break;
    }
    
}

// 移动数据更新 必须实现的方法

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{

}







- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (collectionView == self.collectionView) {
        return 5;
    }else{
        
        return 10;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (collectionView == self.collectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"poolForcell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:1.f];
        
        return cell;
    }else{
    
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"poolForMenu" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor cyanColor];
        
        return cell;
  }
}


// 红线滑动
- (void)registerAsObserver{

    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:@"context"];

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{

    CGFloat x = [[change objectForKey:@"new"] CGPointValue].x;
    CGFloat redX = x/5;
    
    self.redLine.transform = CGAffineTransformMakeTranslation(redX, 0);
    

}


















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
